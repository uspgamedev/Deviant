
extends Panel

const Face1 = preload("res://images/FirstCharFace.jpg")
var isTalking = 0
var mouseInNPC2 = false

func _ready():
	get_node("FaceView1").set_texture(Face1)
	var sceene = parse_sceene("test")
	print(sceene[0]["Panel_1"])
	print(sceene[1]["Panel_2"])
	set_fixed_process(true)
	set_process_input(true)
	pass
	
func parse_sceene(name):
	var dict = {}
	var file = File.new()
	file.open("res://" + name + ".json", file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict[name]

func _fixed_process(delta):
	pass
	
func _input(event):
	verify_click(event)
	pass
	
func verify_click(event):
	if (event.is_action_pressed("click_on_character") and mouseInNPC2):
		get_node("FaceView1").get_node("appear").play("face_appear")
		get_node("NPC2").set_opacity(0)
		get_node("Polygon2D").get_node("dim").play("make_it_dim")
	pass