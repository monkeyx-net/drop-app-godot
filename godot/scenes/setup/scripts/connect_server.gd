extends Control

func _ready() -> void:
	setup()

func setup() -> void:
	var server_url = JsonSettings.server_base_url
	var server_ip = server_url.find("//")
	# Uses meta properties of the Ric Text Label.
	%ClientConnectRTL.text = "[font_size=14][color=#93c5fd]Use link to create a client token - [url=%s/account/tokens]%s/account/tokens[/url][/color][/font_size]" % [JsonSettings.get_sever_url(),JsonSettings.get_sever_url()]
	%AdminConnectRTL.text = "[font_size=14][color=#93c5fd]Use link to create an admin token - [url=%s/admin/settings/tokens]%s/admin/settings/tokens[/url][/color][/font_size]" % [JsonSettings.get_sever_url(),JsonSettings.get_sever_url()]
	%HostServerRTL.meta_clicked.connect(func(url: String): OS.shell_open(url))
	%ClientConnectRTL.meta_clicked.connect(func(url: String): OS.shell_open(url))
	%AdminConnectRTL.meta_clicked.connect(func(url: String): OS.shell_open(url))
	if server_ip != -1:
		var result = server_url.substr(server_ip + 2)
		#var port_open = test_port(result, int(JsonSettings.server_port))
		test_port(result, int(JsonSettings.server_port))
		#%StatusRTL.text = "[color=#00FF00]Port test result '%s' on port %d[/color]"  % [port_open,int(JsonSettings.server_port)]
		%ClientTokenEdit.text = JsonSettings.client_token
		%AdminTokenEdit.text = JsonSettings.admin_token

func test_port(host: String, port: int, timeout: float = 1.0) -> bool:
	var tcp = StreamPeerTCP.new()
	var status = tcp.connect_to_host(host, port)
	if status != OK:
		push_error("Failed to initiate connection. Error: ", status)
		%StatusRTL.text = "[color=#ff0000]Failed to connect to %s[/color]"  % [host]
		return false	
	var time_start = Time.get_ticks_msec()
	while tcp.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		tcp.poll()
		if Time.get_ticks_msec() - time_start > timeout * 1000:
			push_error("Connection timeout after %s seconds" % timeout)
			%StatusRTL.text = "[color=#ff0000]Connection timeout after %s seconds[/color]" % timeout
			tcp.disconnect_from_host()
			return false
	var port_connected = (tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED)	
	if port_connected:
		%StatusRTL.text = "[color=#00ff00]Port %d is open on %s[/color]" % [port, host]
		%GreyCircle.modulate = Color(0.0, 1.0, 0.0)
		tcp.disconnect_from_host()
	else:
		%GreyCircle.modulate = Color(1.0, 0.0, 0.0)
		push_error("Port ", port, " is closed on ", host)
		%StatusRTL.text = "[color=#ff0000]Port %d is closed on %s[/color]" % [port, host]
	return port_connected

func _on_button_pressed() -> void:
	#change to get all text after : or use seperate edit box
	JsonSettings.jsetting.server_port = "3000"
	setup()
