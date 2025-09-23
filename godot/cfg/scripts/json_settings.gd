extends Node

static var jsetting: JsonSettings
# need to this as project setup ie once

var settings_data: Dictionary = {}
var settings_path: String = "res://cfg/app_settings.json"
var application: Dictionary:
	get: return settings_data.get("application", {})    
var authentication: Dictionary:
	get: return settings_data.get("authentication", {})
var server: Dictionary:
	get: return settings_data.get("server", {})
var connection: Dictionary:
	get: return settings_data.get("connection", {})  
var logging: Dictionary:
	get: return settings_data.get("logging", {})
var server_base_url: String:
	get: return server.get("base_url", {})  
var server_port: String:
	get: return server.get("port", {})
	set(value):
		server["port"] = value
		save_settings()
var server_api_version: String:
	get: return server.get("api_version", {})
var app_name: String:
	get: return application.get("name", {})
var app_version: String:
	get: return application.get("version", {})   
var app_description: String:
	get: return application.get("description", {})
var client_token: String:
	get: return authentication.get("client_token", {})
	set(value):
		authentication["client_token"] = value
		save_settings()
var admin_token: String:
	get: return authentication.get("admin_token", {})
	
func _init():
	jsetting = self
	load_settings()
	
func load_settings() -> bool:
	var file_path = settings_path
	if not FileAccess.file_exists(file_path):
		push_error("Settings file not found: " + file_path)
		create_default_settings()
		return false
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open settings file: Error " + str(FileAccess.get_open_error()))
		return false
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_text)
	
	if error != OK:
		push_error("JSON Parse Error: " + json.get_error_message() + " at line " + str(json.get_error_line()))
		return false
	
	settings_data = json.get_data()
	print("Settings loaded successfully from: " + file_path)
	return true

func save_settings() -> bool:
	var file = FileAccess.open(settings_path, FileAccess.WRITE)	
	if file == null:
		push_error("Failed to open settings.json for writing")
		return false
	var json_string = JSON.stringify(settings_data, "\t")
	file.store_string(json_string)
	file.close()
	print("Settings saved successfully")
	return true

# Helper methods for specific settings
func get_endpoint(endpoint_name: String) -> String:
	var endpoints = server.get("endpoints", {})
	return endpoints.get(endpoint_name, "")

func get_sever_url() -> String:
	return "%s:%s" % [server_base_url, server_port]

func get_full_url(endpoint_name: String) -> String:
	var endpoint = get_endpoint(endpoint_name)
	if endpoint.is_empty():
		return ""	
	return "%s:%s%s" % [server_base_url, server_port, endpoint]

func get_auth_token(is_admin: bool = false) -> String:
	return admin_token if is_admin else client_token

func set_auth_token(token: String, is_admin: bool = false) -> void:
	if is_admin:
		authentication["admin_token"] = token
		admin_token = token
	else:
		authentication["client_token"] = token
		client_token = token
	save_settings()

func get_timeout() -> String:
	return connection.get("timeout", {})

func get_retry_attempts() -> String:
	return connection.get("retry_attempts", {})

func get_retry_delay() -> String:
	return connection.get("retry_delay", {})

func get_log_file_path() -> String:
	return logging.get("file_path", "logs/app.log")

# load from file?
func create_default_settings() -> void:
	settings_data = {
		"application": {
			"name": "Drop App",
			"version": "0.0.1",
			"description": "GoDot front end app for Drop OSS"
		},
		"authentication": {
			"client_token": "encrypted_client_generated_token",
			"admin_token": "encrypted_admin_generated_token"
		},
		"server": {
			"base_url": "http://localhost",
			"port": "3000",
			"api_version": "v1",
			"endpoints": {
				  "auth": "/api/v1/auth",
				  "client": "/api/v1/client",
				  "collection": "/api/v1/collection",
				  "companies": "/api/v1/companies",
				  "games": "/api/v1/games",
				  "news": "/api/v1/news",
				  "notifications": "/api/v1/notifications",
				  "object": "/api/v1/object",
				  "screenshots": "/api/v1/screenshots",
				  "settings": "/api/v1/settings",
				  "store": "/api/v1/store",
				  "tags": "/api/v1/tags",
				  "task": "/api/v1/task",
				  "user": "/api/v1/user",
				  "admin_auth": "/api/v1/admin/auth",
				  "admin_company": "/api/v1/company",
				  "admin_game": "/api/v1/game",
				  "admin_import": "/api/v1/import",
				  "admin_library": "/api/v1/library",
				  "admin_news": "/api/v1/news",
				  "admin_settings": "/api/v1/settings",
				  "admin_store": "/api/v1/store",
				  "admin_tags": "/api/v1/tags",
				  "admin_task": "/api/v1/task",
				  "admin_token": "/api/v1/token",
				  "admin_users": "/api/v1/usesr"
			}
		},
		"connection": {
			"timeout": "30000",
			"retry_attempts": "3",
			"retry_delay": "1000"
		},
		"logging": {
			"level": "info",
			"file_path": "logs/app.log"
		}
	}
	
	if save_settings():
		print("Default settings file created")
	else:
		push_error("Failed to create default settings file")

# Method to reload settings (useful if file changes externally)
func reload_settings() -> bool:
	return load_settings()

# Method to reset to default settings
func reset_to_default() -> bool:
	create_default_settings()
	return load_settings()

func load_or_generate_key(crypto: Crypto) -> CryptoKey:
	var keypair = CryptoKey.new()
	# needs to go user path?
	var private_key: String = "cfg/id_rsa.key"
	var public_key: String = "cfg/id_rsa.pub"
	# Try to load existing private key
	if FileAccess.file_exists(private_key):
		if keypair.load(private_key) == OK:
			# TODO log instead
			print("Loaded existing RSA key")
			return keypair
	# TODO log instead
	print("Generating new RSA key...")
	keypair = crypto.generate_rsa(4096)
	if keypair.save(private_key) == OK and keypair.save(public_key, true) == OK:
		# TODO log instead
		print("New RSA key generated and saved")
	return keypair
	
func encrypt_data(crypto: Crypto, keypair: CryptoKey, message: String) -> String:
	var ciphertext = crypto.encrypt(keypair, message.to_utf8_buffer())
	return Marshalls.raw_to_base64(ciphertext)

func decrypt_data(crypto: Crypto, keypair: CryptoKey, encrypted_token: PackedByteArray) -> String:
	if encrypted_token.is_empty():
		push_error("No data to decrypt")
		return "Error"
	var decrypted_bytes = crypto.decrypt(keypair, encrypted_token)
	var decrypted_message = decrypted_bytes.get_string_from_utf8()
	return decrypted_message
