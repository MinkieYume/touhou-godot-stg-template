@tool
extends HBoxContainer

@onready var button = $Button 
@onready var http_Request = $HTTPRequest 
 
func set_to_valid():
	button.icon = ResourceLoader.load("res://addons/version-check/icons/valid.svg")
	button.text = ""

func set_to_invalid(newest: int):
	button.icon = ResourceLoader.load("res://addons/version-check/icons/invalid.svg")
	button.text = "New: " + str(newest)

func set_to_loading():
	button.icon = ResourceLoader.load("res://addons/version-check/icons/loading.svg")
	button.text = ""

func _on_button_pressed():
	load_data()

func load_data():
	set_to_loading()
	$HTTPRequest.request("https://downloads.tuxfamily.org/godotengine/4.0/")
	
func _on_http_request_request_completed(result, response_code, headers, body:PackedByteArray):
	var version_numbers = parse_body_to_versions(body)
	var current_alpha = Engine.get_version_info().status.replace("alpha", "").to_int()
	
	if current_alpha == version_numbers.max():
		set_to_valid()
	else:
		set_to_invalid(version_numbers.max())
	
func parse_body_to_versions(body):
	var version_numbers = []
	
	var parser: XMLParser = XMLParser.new()
	var current_element = ""
	
	parser.open_buffer(body)
	while parser.read() == OK:
		match parser.get_node_type():
			XMLParser.NODE_ELEMENT:
				current_element = parser.get_node_name()
			XMLParser.NODE_TEXT:
				if current_element == "a" and not block_from_list(parser.get_node_data()):
					version_numbers.append((parser.get_node_data().replace("alpha", "")).to_int())
					
	return version_numbers

func block_from_list(item):
	var listed = ["Parent Directory", "pre-alpha", "/"]
	return listed.has(item)
