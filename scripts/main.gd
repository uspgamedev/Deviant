
extends Panel

var NPCS
var SCENES
var ITEMS
var Box

var NPCsNames = [null, null]
var ItemsNames = [null, null]
var ItemsArgs = [null, null]

var isTalking = false
var bagOpen = false
var room

func _ready():
	SCENES = parseJson("dictionaries/scenes")
	NPCS = parseJson("dictionaries/NPCs")
	ITEMS = parseJson("dictionaries/items")
	Box = get_node("DialogueBox")
	loadScene("TestRoom")
	#set_fixed_process(true)
	#set_process_input(true)
	get_node("Bag/ItemList").add_icon_item(load(getItem(0, "Image")))

func _fixed_process(delta):
	pass

# Recieves the name of a json file and returns it's corresponding
# dictionary
func parseJson(name):
	var dict = {}
	var file = File.new()
	file.open("res://resources/assets/" + name + ".json", file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict

# Recieves the name of a scene and loads the room with it's
# NPCs, items and background
func loadScene(name):
	room = SCENES[name]
	get_node("Background").set_texture(load(room["Background"]))
	clearRoom()
	for i in range(room["Characters"].size()):
		var nodeName = "NPC"+str(i)
		get_node(nodeName).set_texture(load(getNPC(i, "Image")))
		get_node(nodeName).set_pos(getPos("Characters", i))
	for i in range(room["Items"].size()):
		var nodeName = "Item"+str(i)
		get_node(nodeName).set_normal_texture(load(getItem(i, "Image")))
		get_node(nodeName).set_pos(getPos("Items", i))

# Recieves the position "num" of the NPC at the scene's "Characters"
# list and returns it's "key" field
func getNPC(num, key):
	var name = room["Characters"][num]["Name"]
	NPCsNames[num] = name
	return NPCS[name][key]

# Recieves the position "num" of the item at the scene's "Items"
# list and returns it's "key" field
func getItem(num, key):
	var name = room["Items"][num]["Name"]
	ItemsNames[num] = name
	ItemsArgs[num] = room["Items"][num]["Args"]
	return ITEMS[name][key]

# Recieves a scene "group" (can be "Items" or "Characters") and
# returns the "pos" value of the element number "num" in the group list
func getPos(group, num):
	var vec = room[group][num]["Pos"]
	return Vector2(vec[0], vec[1])

# Clear all the sprites of the room
func clearRoom():
	for i in range(2):
		get_node("NPC"+str(i)).set_texture(null)
	for i in range(2):
		get_node("Item"+str(i)).set_normal_texture(null)

# Is executed when an NPC is clicked. Runs the dialog associated
# with that NPC
func NPCClick(num):
	if not isTalking:
		isTalking = not isTalking
		runDialogue(getNPC(num, "Dialogue"))

# Interprets the dialogue json with name "name" and executes it's
# functions
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
			get_node(view).set_texture(load(getNPC(num, "Image")))
			get_node(view+"/appear").play("face_appear")
			get_node("NPC"+str(num)).set_opacity(0)
			if pos == 0:
				get_node("DarkLight/dim").play("make_it_dim")
			yield(get_node(view+"/appear"), "finished")
		elif foo == "faceHide":
			var pos = dial[counter]["pos"]
			var char = dial[counter]["char"]
			var num = 0
			var view = "FaceView"+str(pos)
			if NPCsNames[1] == char:
				num = 1
			get_node(view+"/appear").play_backwards("face_appear")
			get_node("NPC"+str(num)).set_opacity(1)
			if pos == 0:
				get_node("DarkLight/dim").play_backwards("make_it_dim")
			yield(get_node(view+"/appear"), "finished")
			get_node(view).set_texture(null)
			isTalking = not isTalking
		elif foo == "dialogueShow":
			var pos = dial[counter]["pos"]
			var text = dial[counter]["text"]
			Box.change_side(pos)
			Box.setAlpha(1)
			Box.printText(text)
			yield(Box, "ended")
			Box.setAlpha(0)
		elif foo == "End":
			break
		counter = str(int(counter) + 1)
			

# Executed when an item is clicked. Runs the function associated
# with that item with the aguments specified in the field "args"
# from SCENES json
func itemClick(num):
	print(num)
	var name = ItemsNames[num]
	var function = ITEMS[name]["Function"]
	var args = ItemsArgs[num]
	if (function == "changeScene"):
		print("Entrou")
		loadScene(args[0])
		
func BagOpen():
	if bagOpen:
		get_node("Bag/ItemList").set_opacity(0)
		bagOpen = false
	else:
		get_node("Bag/ItemList").set_opacity(1)
		bagOpen = true


