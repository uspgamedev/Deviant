
extends Panel

var NPCS
var SCENES
var ITEMS

var NPCsNames = [null, null]
var ItemsNames = [null, null]
var ItemsArgs = [null, null]

var isTalking = false
var room


func _ready():
	SCENES = parse_scene("scenes")
	NPCS = parse_scene("NPCs")
	ITEMS = parse_scene("items")
	loadScene("TestRoom")
	set_fixed_process(true)
	set_process_input(true)
	pass
	
func loadScene(name):
	room = SCENES[name]
	get_node("Background").set_texture(load(room["Background"]))
	clearRoom()
	for i in range(room["Characters"].size()):
		var nodeName = "NPC"+str(i)
		get_node(nodeName).set_normal_texture(getNPC(i, "Body"))
		get_node(nodeName).set_pos(getPos(room["Characters"][i]["Pos"]))
	for i in range(room["Items"].size()):
		var nodeName = "Item"+str(i)
		get_node(nodeName).set_normal_texture(getItem(i, "Image"))
		get_node(nodeName).set_pos(getPos(room["Items"][i]["Pos"]))

func getNPC(num, type):
	var name = room["Characters"][num]["Name"]
	NPCsNames[num] = name
	return load(NPCS[name][type])
	
func getItem(num, type):
	var name = room["Items"][num]["Name"]
	ItemsNames[num] = name
	ItemsArgs[num] = room["Items"][num]["Args"]
	return load(ITEMS[name][type])

func getPos(vec):
	 return Vector2(vec[0], vec[1])
	
func clearRoom():
	for i in range(2):
		get_node("NPC"+str(i)).set_normal_texture(null)
	for i in range(2):
		get_node("Item"+str(i)).set_normal_texture(null)

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

func NPCClick(num):
	if not isTalking:
		isTalking = not isTalking
		get_node("FaceView1").set_texture(getNPC(0, "Face"))
		get_node("FaceView1").get_node("appear").play("face_appear")
		get_node("NPC"+str(num)).set_opacity(0)
		get_node("DarkLight").get_node("dim").play("make_it_dim")
	pass

func itemClick(num):
	print(num)
	var name = ItemsNames[num]
	var function = ITEMS[name]["Function"]
	var args = ItemsArgs[num]
	if (function == "changeScene"):
		print("Entrou")
		loadScene(args[0])
	pass

