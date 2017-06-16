
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
var roomName = null
var room
var ctr

func _ready():
	SCENES = parseJson("dictionaries/scenes")
	NPCS = parseJson("dictionaries/NPCs")
	ITEMS = parseJson("dictionaries/items")
	Box = get_node("DialogueBox")
	loadScene("TestRoom")
	#set_fixed_process(true)
	#set_process_input(true)
	
	# print(get_node("Bag/ItemList").get_item_icon(0))

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
	roomName = name
	get_node("Background").set_texture(load(room["Background"]))
	clearRoom()
	for i in range(room["Characters"].size()):
		var nodeName = "NPC"+str(i)
		var img = load(getNPC(i, "Image"))
		get_node(nodeName).set_texture(img)
		get_node(nodeName).set_pos(getPos("Characters", i))
		get_node(nodeName+"/TextureButton").set_size(Vector2(128, 320))
	for i in range(room["Items"].size()):
		var nodeName = "Item"+str(i)
		var img = load(getItem(i, "Image"))
		get_node(nodeName).set_normal_texture(img)
		get_node(nodeName).set_pos(getPos("Items", i))
		get_node(nodeName).set_size(img.get_size())

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
	print("Top")
	if not isTalking:
		isTalking = true
		runDialogue(getNPC(num, "Dialogue"))

# Interprets the dialogue json with name "name" and executes it's
# functions
func runDialogue(name):
	var dial = parseJson("dialogues/" + name)
	ctr = "1"
	var foo = null
	var cmd = null
	while true:
		cmd = dial[ctr]
		foo = cmd["function"]
		if foo == "faceShow":
			# Executes face show animation for character "char" at
			# screen position "pos"
			var char = cmd["char"]
			var pos = cmd["pos"]
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
			ctr = str(int(ctr) + 1)
		elif foo == "faceHide":
			# Executes face hide animation for character "char" at
			# screen position "pos"
			var char = cmd["char"]
			var pos = cmd["pos"]
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
			ctr = str(int(ctr) + 1)
		elif foo == "dialogueShow":
			# Shows dialogue box with text "text" and pointing to screen
			# position "pos"
			var text = cmd["text"]
			var pos = cmd["pos"]
			Box.change_side(pos)
			Box.get_node("anim").play("pop_up")
			yield(Box.get_node("anim"), "finished")
			Box.printText(text)
			yield(Box, "ended")
			Box.get_node("anim").play_backwards("pop_up")
			yield(Box.get_node("anim"), "finished")
			isTalking = false
			ctr = str(int(ctr) + 1)
		elif foo == "say":
			# Shows text "text" at Log
			var text = cmd["text"]
			get_node("Log").printText(text)
			yield(get_node("Log"), "ended")
			ctr = str(int(ctr) + 1)
		elif foo == "choose":
			# Shows a question "text" and it's possible answers "opts" at Log
			var text = cmd["text"]
			var opts = cmd["opts"]
			var goto = cmd["goto"]
			get_node("Log").printChoose(text, opts)
			yield(get_node("Log"), "ended")
			print(get_node("Log").option)
			ctr = goto[get_node("Log").option]
		elif foo == "End":
			break

# Executed when an item is clicked. Runs the function associated
# with that item with the aguments specified in the field "args"
# from SCENES json
func itemClick(num):
	print(num)
	var name = ItemsNames[num]
	var function = ITEMS[name]["Function"]
	var args = ItemsArgs[num]
	if (function == "changeScene"):
		changeScene(args[0])
	elif (function == "addToBag"):
		addToBag(num)

func changeScene(scene):
	get_node("DarkLight/dim").play("change_scene")
	yield(get_node("DarkLight/dim"), "finished")
	loadScene(scene)
	get_node("DarkLight/dim").play_backwards("change_scene")
	
func addToBag(num):
	get_node("Item"+str(num)).set_pos(Vector2(-100, -100))
	get_node("Bag/ItemList").add_icon_item(load(getItem(num, "Image")))
	SCENES[roomName]["Items"].remove(num)

# Opens bag
func BagOpen():
	if bagOpen:
		get_node("Bag/ItemList").set_pos(Vector2(175, -425))
		bagOpen = false
	else:
		get_node("Bag/ItemList").set_pos(Vector2(0, -425))
		bagOpen = true
