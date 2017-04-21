extends Panel

var priority

func _ready():
	pass

func get_type():
	return "Core"

func set_priority(name):
	priority = name

func get_priority():
	return priority

func set_color(col):
	get_node("Pipe").set_color(col)

func get_color():
	return get_node("Pipe").get_color()
