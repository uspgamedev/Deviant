extends Sprite

var name
var function
var args

func _ready():
	pass
	
func _on_Button_pressed():
	get_parent().run_item_func(name, function, args, get_texture())

func set_info(dic):
	if dic == null:
		set_texture(null)
		get_node("Button").set_size(Vector2(0, 0))
		name = null
		function = null
		args = null
	else:
		var img = load(dic["Image"])
		set_texture(img)
		get_node("Button").set_size(img.get_size())
		name = dic["Name"]
		function = dic["Function"]
		args = dic["Args"]

func get_name():
	return name
