extends Sprite

var dialogue
var name

func _ready():
	pass

func set_info(dic):
	if dic == null:
		set_texture(null)
		get_node("Button").set_size(Vector2(0, 0))
		name = null
		dialogue = null
	else:
		set_texture(load(dic["Image"]))
		get_node("Button").set_size(Vector2(160, 240))
		name = dic["Name"]
		dialogue = dic["Dialogue"]

func get_name():
	return name
	
func _on_Button_pressed():
	get_parent().run_dialogue(dialogue)
	
func _on_mouse_enter():
	if not get_parent().is_block():
		get_parent().get_node("Log").show_text(name)

func _on_mouse_exit():
	if not get_parent().is_block():
		get_parent().get_node("Log").clear_text()
