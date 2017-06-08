extends Control

var wasPressed = false
var isPressed = false
export var option = 0

signal ended
signal pressed
signal chosen

func _ready():
	set_fixed_process(true)
	
func _fixed_process(dt):
	isPressed = Input.is_key_pressed(KEY_SPACE)
	if (not wasPressed and isPressed):
		emit_signal("pressed")
	wasPressed = isPressed

func printText(vec):
	var buffer
	for line in vec:
		buffer = ""
		for i in line:
			get_node("Timer").start()
			yield(get_node("Timer"), "timeout")
			buffer += i
			get_node("Label").set_text(buffer)
		yield(self, "pressed")
	get_node("Label").set_text("")
	emit_signal("ended")
	
func printChoose(text, opts):
	get_node("Label").set_text(text)
	for i in range(3):
		get_node("Button" + str(i) + "/Label").set_text(opts[i])
	yield(self, "chosen")
	get_node("Label").set_text("")
	for i in range(3):
		get_node("Button" + str(i) + "/Label").set_text("")
	emit_signal("ended")
	
func buttonClick(num):
	if (get_node("Button"+str(num)+"/Label").get_text() != ""):
		option = num
		emit_signal("chosen")
	