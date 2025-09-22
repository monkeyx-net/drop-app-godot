extends Control

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
	#JsonSettings.jsetting.server_port = "8080"
	#print("Port number: ", JsonSettings.jsetting.server_port)

	if JsonSettings.admin_token == "encrypted_admin_generated_token" and JsonSettings.client_token == "encrypted_client_generated_token":
		# use call_deffered to allow main scence to fully initialise 
		get_tree().call_deferred("change_scene_to_file", "res://scenes/setup/setup.tscn")	
	
		#var success = JsonSettings.encrypt_data(crypto, keypair, JsonSettings.client_token)
		#JsonSettings.client_token = success
	#var bob:String = JsonSettings.decrypt_data(crypto, keypair,Marshalls.base64_to_raw(JsonSettings.client_token))
	#print ("Decrypted?: ", bob)
