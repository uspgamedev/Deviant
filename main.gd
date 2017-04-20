
extends Panel

#const Face1 = preload("res://images/FirstCharFace.jpg")

var NPCS
var SCENES
var ITENS

func _ready():
	var Face1 = preload("res://images/FirstCharFace.jpg")
	#get_node("FaceView1").set_texture(Face1)
	#var sceene = parse_scene("test")
	#print(sceene["test"][0]["Panel_1"])
	#print(sceene["test"][0]["Panel_2"])
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
	pass
	
func getPos(vec):
	 return Vector2(vec[1], vec[2])
	
func parse_scene(name):
	var dict = {}
	var file = File.new()
	file.open("res://Resources/" + name + ".json", file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict

func _fixed_process(delta):
	pass