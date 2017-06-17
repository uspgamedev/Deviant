extends Sprite

var dialogue
var name

func _ready():
	pass
	
func _on_Button_pressed():
	get_parent().run_dialogue(dialogue)

func set_info(dic):
	if dic == null:
		set_texture(null)
		get_node("Button").set_size(Vector2(0, 0))
		name = null
		dialogue = null
	else:
		set_texture(load(dic["Image"]))
		get_node("Button").set_size(Vector2(192, 320))
		name = dic["Name"]
		dialogue = dic["Dialogue"]

func get_name():
	return name
	
