
extends Control

# Json objects
var NPCS
var SCENES
var ITEMS

# Shortcuts for nodes
var Box
var Log
var MGH
var NPCs = [null, null]
var Items = [null, null]

# Other global variables
var blockClick = false
var bagOpen = false
var roomName = null
var room

func _ready():
	SCENES = parse_json("dictionaries/scenes")
	NPCS = parse_json("dictionaries/NPCs")
	ITEMS = parse_json("dictionaries/items")
	Box = get_node("DialogueBox")
	Log = get_node("Log")
	MGH = get_node("MinigameHandler")
	NPCs[0] = get_node("NPC0")
	NPCs[1] = get_node("NPC1")
	Items[0] = get_node("Item0")
	Items[1] = get_node("Item1")
	load_scene("TestRoom")
	# print(get_node("Bag/ItemList").get_item_icon(0))

# Recieves the name of a json file and returns it's corresponding
# dictionary
func parse_json(name):
	var dict = {}
	var file = File.new()
	file.open("res://resources/assets/" + name + ".json", file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict

# Recieves the name of a scene and loads the room with it's
# NPCs, items and background
func load_scene(name):
	room = SCENES[name]
	roomName = name
	get_node("Background").set_texture(load(room["Background"]))
	clear_room()
	for i in range(room["Characters"].size()):
		NPCs[i].set_info(get_NPC(i))
		NPCs[i].set_pos(get_pos("Characters", i))
	for i in range(room["Items"].size()):
		Items[i].set_info(get_item(i))
		Items[i].set_pos(get_pos("Items", i))

# Recieves the position "num" of the NPC at the scene's "Characters"
# list and returns it's "key" field
func get_NPC(num, key="All"):
	var name = room["Characters"][num]["Name"]
	var ret = {}
	ret["Name"] = name
	ret["Image"] = NPCS[name]["Image"]
	ret["Dialogue"] = NPCS[name]["Dialogue"]
	if key == "All":
		return ret
	return ret[key]
	
# Recieves the position "num" of the item at the scene's "Items"
# list and returns it's "key" field
func get_item(num, key="All"):
	var ret = {}
	var name = room["Items"][num]["Name"]
	ret["Name"] = name
	ret["Args"] = room["Items"][num]["Args"]
	ret["Image"] = ITEMS[name]["Image"]
	ret["Function"] = ITEMS[name]["Function"]
	if key == "All":
		return ret
	return ret[key]

# Recieves a scene "group" (can be "Items" or "Characters") and
# returns the "pos" value of the element number "num" in the group list
func get_pos(group, num):
	var vec = room[group][num]["Pos"]
	return Vector2(vec[0], vec[1])
	
func get_num(name):
	for i in range(room["Characters"].size()):
		if room["Characters"][i]["Name"] == name:
			return i
	for i in range(room["Items"].size()):
		if room["Items"][i]["Name"] == name:
			return i
	return null

# Clear all the sprites of the room
func clear_room():
	for i in range(2):
		NPCs[i].set_info(null)
	for i in range(2):
		Items[i].set_info(null)

# Interprets the dialogue json with name "name" and executes it's
# functions
func run_dialogue(name):
	if blockClick:
		return
	var dial = parse_json("dialogues/" + name)
	var ctr = "1"
	var foo = null
	var cmd = null
	if bagOpen:
		_bag_open()
	blockClick = true
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
			if NPCs[1].get_name() == char:
				num = 1
			get_node(view).set_texture(NPCs[num].get_texture())
			get_node(view+"/appear").play("face_appear")
			NPCs[num].set_opacity(0)
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
			if NPCs[1].get_name() == char:
				num = 1
			get_node(view+"/appear").play_backwards("face_appear")
			NPCs[num].set_opacity(1)
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
			Box.print_text(text)
			yield(Box, "ended")
			Box.get_node("anim").play_backwards("pop_up")
			yield(Box.get_node("anim"), "finished")
			ctr = str(int(ctr) + 1)
		elif foo == "say":
			# Shows text "text" at Log
			var text = cmd["text"]
			Log.print_text(text)
			yield(Log, "ended")
			ctr = str(int(ctr) + 1)
		elif foo == "choose":
			# Shows a question "text" and it's possible answers "opts" at Log
			var text = cmd["text"]
			var opts = cmd["opts"]
			var goto = cmd["goto"]
			Log.print_choose(text, opts)
			yield(Log, "ended")
			ctr = goto[Log.option]
		elif foo == "End":
			blockClick = false
			break

# Executed when an item is clicked. Runs the function associated
# with that item with the aguments specified in the field "args"
# from SCENES json
func run_item_func(name, foo, args, img):
	if blockClick:
		return
	blockClick = true
	if (foo == "changeScene"):
		var dim = get_node("DarkLight/dim")
		dim.play("change_scene")
		yield(dim, "finished")
		load_scene(args[0])
		dim.play_backwards("change_scene")
	elif (foo == "addToBag"):
		add_to_bag(name, img)
	blockClick = false

func change_scene(scene):
	var dim = get_node("DarkLight/dim")
	dim.play("change_scene")
	yield(dim, "finished")
	load_scene(scene)
	dim.play_backwards("change_scene")
	
func add_to_bag(name, img):
	var num = get_num(name)
	Items[num].set_pos(Vector2(-100, -100))
	get_node("Bag/ItemList").add_icon_item(img)
	SCENES[roomName]["Items"].remove(num)

# Open/close bag
func _bag_open():
	if blockClick:
		return
	if bagOpen:
		get_node("Bag/ItemList").set_pos(Vector2(84, -425))
		bagOpen = false
	else:
		get_node("Bag/ItemList").set_pos(Vector2(0, -425))
		bagOpen = true


func _on_TestButton_pressed():
	blockClick = true
	var Time = get_node("Timer")
	MGH.run_minigame("flowfree", null)
	yield(MGH, "ended")
	Time.start()
	yield(Time, "timeout")
	MGH.game_close()
	MGH.run_minigame("passBreaker", null)
	yield(MGH, "ended")
	Time.start()
	yield(Time, "timeout")
	MGH.game_close()
	blockClick = false
