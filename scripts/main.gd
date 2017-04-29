
extends Panel

var NPCS
var SCENES
var ITENS
var isTalking = 0
var mouseInNPC2 = false
var room
var dialogue

func _ready():
	SCENES = parse_scene("scenes")
	NPCS = parse_scene("NPCs")
	ITENS = parse_scene("itens")
	loadScene("TestRoom")
	set_fixed_process(true)
	set_process_input(true)
	pass
	
func loadScene(name):
	room = SCENES[name]
	get_node("Background").set_texture(load(room["Background"]))
	for i in range(room["Characters"].size()):
		get_node("NPC"+str(i+1)).set_normal_texture(getNPCImage(i, "Body"))
		get_node("NPC"+str(i+1)).set_pos(getPos(room["Characters"][i]))
	for i in range(room["Itens"].size()):
		get_node("Item"+str(i+1)).set_normal_texture(getItemImage(i, "Image"))
		get_node("Item"+str(i+1)).set_pos(getPos(room["Itens"][i]))

func getNPCImage(num, type):
	return load(NPCS[room["Characters"][num][0]][type])
	
func getItemImage(num, type):
	return load(ITENS[room["Itens"][num][0]][type])

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

func _on_NPC1_pressed():
	print("Entrow")
	get_node("FaceView1").set_texture(getNPCImage(0, "Face"))
	get_node("FaceView1").get_node("appear").play("face_appear")
	get_node("NPC1").set_opacity(0)
	get_node("DarkLight").get_node("dim").play("make_it_dim")
	pass

func _on_NPC2_pressed():
	print("Entrow")
	pass
