extends Panel

func _ready():
	pass
	
func get_color():
	return get_node("Pipe").get_color()

func get_type():
	return "Tile"

func set_color(col):
	get_node("Pipe").set_color(col)
