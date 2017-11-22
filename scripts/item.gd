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
	
func get_nick():
	return nick
	
func _on_Button_pressed():
	var prt = get_parent()
	if not prt.is_block() and (not prt.get_waiting() or prt.get_waiting() == name):
		prt.run_item_func(name, function, args, get_texture())

func _on_mouse_enter():
	var prt = get_parent()
	if not prt.is_block() and (not prt.get_waiting() or prt.get_waiting() == name):
		prt.Log.show_text(nick)

func _on_mouse_exit():
	var prt = get_parent()
	if not prt.is_block() and (not prt.get_waiting() or prt.get_waiting() == name):
		prt.Log.clear_text()
