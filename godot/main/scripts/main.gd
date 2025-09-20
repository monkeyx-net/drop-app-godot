extends Control

# refences the JsonSettings via autoload

func _ready() -> void:
	print("App Name: ", JsonSettings.app_name)
	print("App Version: ", JsonSettings.app_version)
	var auth_url = JsonSettings.get_full_url("auth")
	print("Auth Endpoint: ", auth_url)
	auth_url = JsonSettings.get_full_url("admin_auth")
	print("Admin Auth Endpoint: ", auth_url)
	print("Port number: ", JsonSettings.jsetting.server_port)
	print ("Client token: ", JsonSettings.client_token)
	print ("Admin token: ", JsonSettings.admin_token)
#	JsonSettings.set_auth_token("Bob")
	#JsonSettings.jsetting.server_port = 8080
	#print("Port number: ", JsonSettings.jsetting.server_port)
