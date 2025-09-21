extends Control

# refences the JsonSettings via autoload

func _ready() -> void:
	var crypto: Crypto = Crypto.new()
	var keypair: CryptoKey = JsonSettings.load_or_generate_key(crypto)
	var auth_url: String = JsonSettings.get_full_url("auth")
	print("App Name: ", JsonSettings.app_name)
	print("App Version: ", JsonSettings.app_version)
	print("Auth Endpoint: ", auth_url)
	auth_url = JsonSettings.get_full_url("admin_auth")
	print("Admin Auth Endpoint: ", auth_url)
	print("Port number: ", JsonSettings.server_port)
	print ("Client token: ", JsonSettings.client_token)
	print ("Admin token: ", JsonSettings.admin_token)
	#JsonSettings.jsetting.server_port = 8080
	#print("Port number: ", JsonSettings.jsetting.server_port)


	var success = JsonSettings.encrypt_data(crypto, keypair, JsonSettings.client_token)
	JsonSettings.client_token = success
	#if success:
	var bob:String = JsonSettings.decrypt_data(crypto, keypair,Marshalls.base64_to_raw(JsonSettings.client_token))
	print ("Decrypted?: ", bob)
