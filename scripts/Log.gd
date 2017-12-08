extends Control

onready var STT = get_node("ShowTextTimer")

export var option = 0

var wasPressed = false
var isPressed = false
var Buttons = []
var texts = [null, null]

signal ended
signal pressed
signal chosen

func _ready():
	for i in range(3):
		Buttons.append(get_node("Button"+str(i)))
	remove_buttons()
	set_process_input(true)
	
func _input(event):
	if (event.is_action_pressed("next_dialog")):
		isPressed = true
		wasPressed = true
	if (event.is_action_released("next_dialog")):
		isPressed = false
		if wasPressed and (not isPressed):
			emit_signal("pressed")
		wasPressed = false

func print_text(vec):
	var buffer
	clear_text()
	for line in vec:
		buffer = ""
		for i in line:
			if isPressed:
				yield(self, "pressed")
				show_text(line)
				break
			get_node("Timer").start()
			yield(get_node("Timer"), "timeout")
			buffer += i
			show_text(buffer)
		yield(self, "pressed")
	clear_text()
	emit_signal("ended")
	
func print_choose(text, opts):
	show_text(text)
	add_buttons(opts)
	for i in range(3):
		if opts[i] != "":
			get_node("Button" + str(i) + "/Label").set_text(opts[i])
	yield(self, "chosen")
	clear_text()
	for i in range(3):
		if opts[i] != "":
			get_node("Button" + str(i) + "/Label").set_text("")
	remove_buttons()
	emit_signal("ended")
	
func show_text(text):
	if not texts[1]:
		get_node("Label").set_text(text)
	texts[0] = text

func show_timed_text(text):
	texts[1] = text
	get_node("Label").set_text(text)
	STT.start()
	yield(STT, "timeout")
	texts[1] = null
	if texts[0]:
		show_text(texts[0])
	else:
		clear_text()

func clear_text():
	if not texts[1]:
		get_node("Label").set_text("")
	texts[0] = null

func add_buttons(opts):
	for i in range(3):
		if opts[i] != "":
			add_child(Buttons[i])

func remove_buttons():
	for i in range(3):
		remove_child(Buttons[i])
	
func _on_Button_click(num):
	if (get_node("Button"+str(num)+"/Label").get_text() != ""):
		option = num
		emit_signal("chosen")
	