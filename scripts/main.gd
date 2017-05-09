
extends Panel

var NewBox = preload("res://resources/scenes/dialogueBox.tscn")

var NPCS
var SCENES
var ITEMS
var Box

var NPCsNames = [null, null]
var ItemsNames = [null, null]
var ItemsArgs = [null, null]

var isTalking = false
var room

func _ready():
	SCENES = parseJson("dictionaries/scenes")
	NPCS = parseJson("dictionaries/NPCs")
	ITEMS = parseJson("dictionaries/items")
	Box = NewBox.instance()
	Box.set_pos(Vector2(500, 200))
	add_child(Box)
	loadScene("TestRoom")
	set_fixed_process(true)
	set_process_input(true)
	pass
	
func parseJson(name):
	var dict = {}
	var file = File.new()
	file.open("res://resources/assets/" + name + ".json", file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict

func _fixed_process(delta):
	pass
	
func loadScene(name):
	room = SCENES[name]
	get_node("Background").set_texture(load(room["Background"]))
	clearRoom()
	for i in range(room["Characters"].size()):
		var nodeName = "NPC"+str(i)
		get_node(nodeName).set_normal_texture(load(getNPC(i, "Body")))
		get_node(nodeName).set_pos(getPos(room["Characters"][i]["Pos"]))
	for i in range(room["Items"].size()):
		var nodeName = "Item"+str(i)
		get_node(nodeName).set_normal_texture(getItem(i, "Image"))
		get_node(nodeName).set_pos(getPos(room["Items"][i]["Pos"]))

func getNPC(num, type):
	var name = room["Characters"][num]["Name"]
	NPCsNames[num] = name
	return NPCS[name][type]
	
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

func NPCClick(num):
	if not isTalking:
		isTalking = not isTalking
		runDialogue(getNPC(num, "Dialogue"))
	pass
	
func runDialogue(name):
	var dial = parseJson("dialogues/" + name)
	var counter = "1"
	var foo
	while true:
		foo = dial[counter]["function"]
		if foo == "faceShow":
			var pos = dial[counter]["pos"]
			var char = dial[counter]["char"]
			var num = 0
			var view = "FaceView"+str(pos)
			if NPCsNames[1] == char:
				num = 1
			get_node(view).set_texture(load(getNPC(num, "Face")))
			get_node(view).get_node("appear").play("face_appear")
			get_node("NPC"+str(num)).set_opacity(0)
			if pos == 0:
				get_node("DarkLight").get_node("dim").play("make_it_dim")
			yield(get_node(view).get_node("appear"), "finished")
		elif foo == "dialogueShow":
			var pos = dial[counter]["pos"]
			var text = dial[counter]["text"]
			Box.change_side(0)
			Box.setAlpha(1)
			Box.printText(text)
			yield(Box, "ended")
			Box.setAlpha(0)
		elif foo == "End":
			break
		counter = str(int(counter) + 1)
			
			
	

func itemClick(num):
	print(num)
	var name = ItemsNames[num]
	var function = ITEMS[name]["Function"]
	var args = ItemsArgs[num]
	if (function == "changeScene"):
		print("Entrou")
		loadScene(args[0])
	pass

