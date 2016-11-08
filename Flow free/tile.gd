extends Panel

var color = "White"

func _ready():
	pass
	
func get_color():
	return color

func get_type():
	return "Tile"

func set_color(r, g, b, name):
	color = name
	get_node("Pipe").set_color(Color(r, g, b))
