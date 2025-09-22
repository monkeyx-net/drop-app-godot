extends Label

func _ready() -> void:
	var server_url = JsonSettings.server_base_url
	var server_ip = server_url.find("//")
	if server_ip != -1:
		var result = server_url.substr(server_ip + 2)
		var port_open = test_port(result, int(JsonSettings.server_port))
		print("Port test result: ", port_open)

func test_port(host: String, port: int, timeout: float = 1.0) -> bool:
	var tcp = StreamPeerTCP.new()
	var status = tcp.connect_to_host(host, port)
	if status != OK:
		push_error("Failed to initiate connection. Error: ", status)
		%ConnectionStatusLabel.text = "Failed to connect to %s"  % [host]
		return false	
	var time_start = Time.get_ticks_msec()
	while tcp.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		tcp.poll()
		if Time.get_ticks_msec() - time_start > timeout * 1000:
			push_error("Connection timeout after ", timeout, " seconds")
			tcp.disconnect_from_host()
			return false
	var port_connected = (tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED)	
	if port_connected:
		%ConnectionStatusLabel.text = "Port %d is open on %s" % [port, host]
		%GreyCircle.modulate = Color(0.0, 1.0, 0.0)
		tcp.disconnect_from_host()
	else:
		%GreyCircle.modulate = Color(1.0, 0.0, 0.0)
		push_error("Port ", port, " is CLOSED on ", host)
		%ConnectionStatusLabel.text = "Port %d is closed on %s" % [port, host]
	return port_connected
