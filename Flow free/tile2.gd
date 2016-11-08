extends Panel

var color = "White"
var priority

func _ready():
	pass
	
func get_type():
	return "Core"

func set_priority(name):
	priority = name

func get_priority():
	return priority

func set_color(r, g, b, name):
	color = name
	get_node("Pipe").set_color(Color(r, g, b))

func get_color():
	return color