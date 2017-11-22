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
	var prt = get_parent()
	if not prt.is_block() and (not prt.get_waiting() or prt.get_waiting() == name):
		prt.run_dialogue(dialogue)
	
func _on_mouse_enter():
	var prt = get_parent()
	if not prt.is_block() and (not prt.get_waiting() or prt.get_waiting() == name):
		prt.Log.show_text(name)

func _on_mouse_exit():
	var prt = get_parent()
	if not prt.is_block() and (not prt.get_waiting() or prt.get_waiting() == name):
		prt.Log.clear_text()
