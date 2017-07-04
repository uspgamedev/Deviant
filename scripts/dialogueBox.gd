extends Node2D

var wasPressed = false
var isPressed = false

signal pressed
signal ended

func _ready():
	set_process_input(true)
	get_node("sprite").set_opacity(0)
	
func _input(event):
	if (event.is_action_pressed("next_dialog")):
		isPressed = true
		wasPressed = true
	if (event.is_action_released("next_dialog")):
		isPressed = false
		if wasPressed and (not isPressed):
			emit_signal("pressed")
		wasPressed = false

# Sets the alpha color value of all tiles to "val"
#func set_alpha(val):
#	for i in range(13):
#		get_node("sprite/Tile"+str(i)).set_modulate(Color(1, 1, 1, val))

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
func print_text(vec):
	var buffer
	for line in vec:
		buffer = ""
		for i in line:
			if isPressed:
				yield(self, "pressed")
				get_node("sprite/Text").set_text(line)
				break
			get_node("Timer").start()
			yield(get_node("Timer"), "timeout")
			buffer += i
			get_node("sprite/Text").set_text(buffer)
		yield(self, "pressed")
	get_node("sprite/Text").set_text("")
	emit_signal("ended")
