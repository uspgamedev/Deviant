extends Control

var wasPressed = false
var isPressed = false
export var option = 0

signal ended
signal pressed
signal chosen

func _ready():
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
	for line in vec:
		buffer = ""
		for i in line:
			if isPressed:
				yield(self, "pressed")
				get_node("Label").set_text(line)
				break
			get_node("Timer").start()
			yield(get_node("Timer"), "timeout")
			buffer += i
			get_node("Label").set_text(buffer)
		yield(self, "pressed")
	get_node("Label").set_text("")
	emit_signal("ended")
	
func print_choose(text, opts):
	get_node("Label").set_text(text)
	for i in range(3):
		get_node("Button" + str(i) + "/Label").set_text(opts[i])
	yield(self, "chosen")
	get_node("Label").set_text("")
	for i in range(3):
		get_node("Button" + str(i) + "/Label").set_text("")
	emit_signal("ended")
	
func _on_Button_click(num):
	if (get_node("Button"+str(num)+"/Label").get_text() != ""):
		option = num
		emit_signal("chosen")
	