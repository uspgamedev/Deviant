
extends YSort

const NPC = preload("res://resources/scenes/NPC.tscn")
const Item = preload("res://resources/scenes/item.tscn")

const actList = ["ATO 1: UMA NOVA MISSÃO", "ATO 2: INVESTIGAÇÃO", "CONTINUA..."]

# Json objects
var NPCS
var SCENES
var ITEMS
var SPECIALS

# Shortcuts for nodes
var Box
var Log
var MGH
var NPCs = []
var Items = []
var Specials = []

# Other global variables
var blockClick = false
var bagOpen = false
var roomName = null
var room
var act = 0

signal finished_act

func _ready():
	SCENES = parse_json("dictionaries/scenes")
	NPCS = parse_json("dictionaries/NPCs")
	ITEMS = parse_json("dictionaries/items")
	SPECIALS = parse_json("dictionaries/specials")
	Box = get_node("DialogueBox")
	Log = get_node("Log")
	MGH = get_node("MinigameHandler")
	change_act(1)
	load_scene("MeetingRoom")

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
	Log.clear_text()
	clear_room()
	for i in range(room["Characters"].size()):
		NPCs.append(NPC.instance())
		NPCs[i].set_info(get_NPC(i))
		NPCs[i].set_pos(get_pos("Characters", i))
		add_child(NPCs[i])
	for i in range(room["Items"].size()):
		Items.append(Item.instance())
		Items[i].set_info(get_item(i))
		Items[i].set_pos(get_pos("Items", i))
		add_child(Items[i])
	for i in range(room["Specials"].size()):
		var ins = get_special(i)
		Specials.append(ins.instance())
		Specials[i].set_pos(get_pos("Specials", i))
		add_child(Specials[i])

# Recieves a position "num" of the NPC at the scene's "Characters"
# list and returns it's "key" field. If key == "All", returns a dictionary
# with all keys
func get_NPC(num, key="All"):
	var name = room["Characters"][num]["Name"]
	var ret = {}
	ret["Name"] = name
	ret["Image"] = NPCS[name]["Image"]
	ret["Dialogue"] = NPCS[name]["Dialogue"]
	if key == "All":
		return ret
	return ret[key]
	
# Recieves a position "num" of the item at the scene's "Items"
# list and returns it's "key" field. If key == "All", returns a dictionary
# with all keys
func get_item(num, key="All"):
	var ret = {}
	var name = room["Items"][num]["Name"]
	ret["Name"] = name
	ret["Args"] = room["Items"][num]["Args"]
	ret["Image"] = ITEMS[name]["Image"]
	ret["Function"] = ITEMS[name]["Function"]
	ret["Nickname"] = ITEMS[name]["Nickname"]
	if key == "All":
		return ret
	return ret[key]

# Recieves a position "num" at the scene's "Specials"
# list and returns it's correspondent scene
func get_special(num):
	var name = room["Specials"][num]["Name"]
	return load(SPECIALS[name])

# Recieves a scene "group" (can be "Items" or "Characters") and
# returns the "pos" value of the element number "num" in the group list
func get_pos(group, num):
	var vec = room[group][num]["Pos"]
	return Vector2(vec[0], vec[1])

# Returns the number of the object named "name" at the room's list
func get_num(name):
	for i in range(NPCs.size()):
		#print(room["Characters"][i]["Name"] + " == " + name)
		if NPCs[i].get_name() == name:
			return i
	for i in range(Items.size()):
		#print(room["Items"][i]["Name"] + " == " + name)
		if Items[i].get_name() == name:
			return i
	for i in range(Specials.size()):
		if Specials[i].get_name() == name:
			return i
	return null

# Clear all the sprites of the room
func clear_room():
	for i in range(NPCs.size()):
		NPCs[i].queue_free()
	for i in range(Items.size()):
		Items[i].queue_free()
	for i in range(Specials.size()):
		Specials[i].queue_free()
	NPCs = []
	Items = []
	Specials = []

# Interprets the dialogue json with name "name" and executes it's
# functions
func run_dialogue(name):
	if blockClick or name == "":
		return
	var dial = parse_json("dialogues/" + name)
	var ctr = "1"
	var mem = "0"
	var foo = null
	var cmd = null
	if bagOpen:
		_bag_open()
	blockClick = true
	Log.clear_text()
	while true:
		cmd = dial[ctr]
		foo = cmd["func"]
		if mem != ctr:
			mem = ctr
		else:
			print("Você caiu no loop infinito do while hur-dur!!")
			break
		if foo == "faceShow":
			# Executes face show animation for character "char" at
			# screen position "pos"
			var char = cmd["char"]
			var pos = cmd["pos"]
			var num = get_num(char)
			var view = "FaceView"+str(pos)
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
			var num = get_num(char)
			var view = "FaceView"+str(pos)
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
		elif foo == "special":
			var obj = cmd["targ"]
			var num = get_num(obj)
			Specials[num].specFunc()
			ctr = str(int(ctr) + 1)
		elif foo == "jump":
			ctr = cmd["to"]
		elif foo == "changeDialogue":
			var char = cmd["char"]
			NPCs[get_num(char)].dialogue = ""
			NPCS[char]["Dialogue"] = ""
			ctr = str(int(ctr) + 1)
		elif foo == "End":
			break
	if name == "Rafael_meeting_1":
		var dim = get_node("DarkLight/dim")
		get_node("DarkLight/Act").set_text(actList[1])
		dim.play("change_act")
		yield(dim, "finished")
		dim.play_backwards("show_text")
		yield(dim, "finished")
		get_node("DarkLight/Act").set_text(actList[2])
		dim.play("show_text")
		yield(dim, "finished")
		get_tree().quit()
	blockClick = false

# Executed when an item is clicked. Runs the function associated
# with that item with the aguments specified in the field "args"
# from SCENES json
func run_item_func(name, foo, args, img):
	if blockClick:
		return
	blockClick = true
	if (foo == "changeScene"):
		if args[0] == "":
			var Time = get_node("Timer")
			Log.show_text("O seu personagem se recusa a mudar de sala!")
			Time.start()
			yield(Time, "timeout")
		else:
			var dim = get_node("DarkLight/dim")
			dim.play("change_scene")
			yield(dim, "finished")
			load_scene(args[0])
			dim.play_backwards("change_scene")
	elif (foo == "addToBag"):
		add_to_bag(name, args[0])
	elif (foo == "runMinigame"):
		#get_tree().change_scene("res://resources/scenes/minigames/flowfree/flowfreeCanvas.xscn")
		_on_TestButton_pressed()
	blockClick = false

# Dims screen and change scene to "scene"
func change_scene(scene):
	var dim = get_node("DarkLight/dim")
	dim.play("change_scene")
	yield(dim, "finished")
	load_scene(scene)
	dim.play_backwards("change_scene")

# If "who" == "self", add item "name" to the bag and remove item from
# the room, else add "who" to the bag and remove nothing from the room
func add_to_bag(name, who):
	if who == "self":
		var num = get_num(name)
		var img = Items[num].get_texture()
		Items[num].set_pos(Vector2(-100, -100))
		get_node("Bag/ItemList").add_icon_item(img)
		SCENES[roomName]["Items"].remove(num)
	else:
		var item = load(ITEMS[who]["Image"])
		get_node("Bag/ItemList").add_icon_item(item)

# Open/close bag
func _bag_open():
	if blockClick:
		print("Hey")
		return
	if bagOpen:
		get_node("Bag/ItemList").set_pos(Vector2(0, -850))
		bagOpen = false
	else:
		get_node("Bag/ItemList").set_pos(Vector2(0, -425))
		bagOpen = true

func is_block():
	return blockClick

func change_act(a):
	blockClick = true
	var dim = get_node("DarkLight/dim")
	get_node("DarkLight/Act").set_text(actList[a-1])
	dim.play("change_act")
	yield(dim, "finished")
	if a == 1:
		var anim = dim.get_animation("change_act")
		anim.add_track(0, 2)
		anim.track_set_path(2, ".:color")
		anim.track_insert_key(2, 0, Color(0, 0, 0, 0))
		anim.track_insert_key(2, 0.5, Color(0, 0, 0, 1))
		dim.add_animation("change_act", anim)
	dim.play_backwards("change_act")
	yield(dim, "finished")
	blockClick = false
	emit_signal("finished_act")

# Test
func _on_TestButton_pressed():
	#if blockClick:
	#	return
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

func _on_ItemList_item_activated( index ):
	get_node("Bag/ItemList").remove_item(index)
	Log.show_text("*Você bebe o copo de café*")
	get_node("Timer").start()
	yield(get_node("Timer"), "timeout")
	Log.clear_text()
