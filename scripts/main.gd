
extends Panel

var NPCS
var SCENES
var ITENS
var isTalking = 0
var mouseInNPC2 = false

func _ready():
	SCENES = parse_scene("scenes")
	NPCS = parse_scene("NPCs")
	ITENS = parse_scene("itens")
	var room = SCENES["TestRoom"]
	get_node("Background").set_texture(load(room["Background"]))
	get_node("NPC1").set_texture(load(NPCS[room["Characters"][0][0]]["Body"]))
	get_node("NPC1").set_pos(getPos(room["Characters"][0]))
	get_node("NPC2").set_texture(load(NPCS[room["Characters"][1][0]]["Body"]))
	get_node("NPC2").set_pos(getPos(room["Characters"][1]))
	get_node("Item1").set_texture(load(ITENS[room["Itens"][0][0]]["Image"]))
	get_node("Item1").set_pos(getPos(room["Itens"][0]))
	set_fixed_process(true)
	set_process_input(true)
	pass

func getPos(vec):
	 return Vector2(vec[1], vec[2])

func parse_scene(name):
	var dict = {}
	var file = File.new()
	file.open("res://resources/assets/dictionaries/" + name + ".json", file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict

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
