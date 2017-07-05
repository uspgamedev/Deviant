extends Sprite

var name
var function
var args
var nick

func _ready():
	pass

func set_info(dic):
	if dic == null:
		set_texture(null)
		get_node("Button").set_size(Vector2(0, 0))
		name = null
		function = null
		args = null
		nick = null
	else:
		var img = load(dic["Image"])
		set_texture(img)
		get_node("Button").set_size(img.get_size())
		name = dic["Name"]
		function = dic["Function"]
		args = dic["Args"]
		nick = dic["Nickname"]

func get_name():
	return name
	
func _on_Button_pressed():
	if not get_parent().is_block():
		get_parent().run_item_func(name, function, args, get_texture())

func _on_mouse_enter():
	if not get_parent().is_block():
		get_parent().get_node("Log").show_text(nick)

func _on_mouse_exit():
	if not get_parent().is_block():
		get_parent().get_node("Log").clear_text()
