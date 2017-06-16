extends Control

var wasPressed = false
var isPressed = false

signal pressed
signal ended

func _ready():
	set_fixed_process(true)
	get_node("sprite").set_opacity(0)
	
func _fixed_process(dt):
	isPressed = Input.is_key_pressed(KEY_SPACE)
	if (not wasPressed and isPressed):
		emit_signal("pressed")
	wasPressed = isPressed

# Sets the alpha color value of all tiles to "val"
func setAlpha(val):
	for i in range(13):
		get_node("sprite/Tile"+str(i)).set_modulate(Color(1, 1, 1, val))

# Change the side of the dialogue arrow (the tip which is pointed
# to the NPC that is talking)
func change_side(side):
	var sp = "sprite/Tile"
	if (side == 0):
		get_node(sp+"1").set_frame(3)
		get_node(sp+"10").set_frame(1)
		get_node(sp+"12").set_modulate(Color(1, 1, 1, 1))
		get_node(sp+"13").set_modulate(Color(1, 1, 1, 0))
	else:
		get_node(sp+"1").set_frame(1)
		get_node(sp+"10").set_frame(3)
		get_node(sp+"12").set_modulate(Color(1, 1, 1, 0))
		get_node(sp+"13").set_modulate(Color(1, 1, 1, 1))

# Shows each string of "vec" at the diague box, each at a time
func printText(vec):
	var buffer
	for line in vec:
		buffer = ""
		for i in line:
			if (not wasPressed) and isPressed:
				buffer = line
				get_node("sprite/Text").set_text(buffer)
				break
			get_node("Timer").start()
			yield(get_node("Timer"), "timeout")
			buffer += i
			get_node("sprite/Text").set_text(buffer)
		yield(self, "pressed")
	get_node("sprite/Text").set_text("")
	emit_signal("ended")
