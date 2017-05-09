extends Control

const LPoint = preload("res://resources/assets/images/DialoguePointLeft.jpg")
const RPoint = preload("res://resources/assets/images/DialoguePointRight.jpg")
const LBorder = preload("res://resources/assets/images/DialogueLeftBorder.jpg")
const RBorder = preload("res://resources/assets/images/DialogueRightBorder.jpg")

var wasPressed = false
var isPressed = false

signal pressed
signal ended

func _ready():
	set_fixed_process(true)
	setAlpha(0)
	pass
	
func _fixed_process(dt):
	isPressed = Input.is_key_pressed(KEY_SPACE)
	if (not wasPressed and isPressed):
		emit_signal("pressed")
	wasPressed = isPressed
	
func setAlpha(val):
	for i in range(12):
		get_node("DialogueTile"+str(i)).set_modulate(Color(1, 1, 1, val))
	
func change_side(side):
	if (side == 0):
		get_node("DialogueTile1").set_texture(LPoint)
		get_node("DialogueTile1").set_pos(Vector2(-163, -29))
		get_node("DialogueTile10").set_texture(RBorder)
	else:
		get_node("DialogueTile1").set_texture(LBorder)
		get_node("DialogueTile1").set_pos(Vector2(-116, -29))
		get_node("DialogueTile10").set_texture(RPoint)
	
func printText(vec):
	var buffer
	for line in vec:
		buffer = ""
		for i in line:
			get_node("Timer").start()
			yield(get_node("Timer"), "timeout")
			buffer += i
			get_node("Text").set_text(buffer)
		yield(self, "pressed")
	get_node("Text").set_text("")
	emit_signal("ended")
			
	pass
