extends Control

var wasPressed = false
var isPressed = false

signal pressed
signal ended

func _ready():
	set_fixed_process(true)
	setAlpha(0)
	
func _fixed_process(dt):
	isPressed = Input.is_key_pressed(KEY_SPACE)
	if (not wasPressed and isPressed):
		emit_signal("pressed")
	wasPressed = isPressed

# Sets the alpha color value of all tiles to "val"
func setAlpha(val):
	for i in range(13):
		get_node("Tile"+str(i)).set_modulate(Color(1, 1, 1, val))

# Change the side of the dialogue arrow (the tip which is pointed
# to the NPC that is talking)
func change_side(side):
	if (side == 0):
		get_node("Tile1").set_frame(3)
		get_node("Tile10").set_frame(1)
		get_node("Tile12").set_modulate(Color(1, 1, 1, 1))
		get_node("Tile13").set_modulate(Color(1, 1, 1, 0))
	else:
		get_node("Tile1").set_frame(1)
		get_node("Tile10").set_frame(3)
		get_node("Tile12").set_modulate(Color(1, 1, 1, 0))
		get_node("Tile13").set_modulate(Color(1, 1, 1, 1))

# Shows each string of "vec" at the diague box, each at a time
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
