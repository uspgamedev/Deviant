extends Control

func _ready():
	update()
	pass

func get_type():
	return "Core"

func set_color(col):
	get_node("Pipe").set_color(col)

func get_color():
	return get_node("Pipe").get_color()

func _draw():
	draw_circle(Vector2(30, 30), 20, Color(0, 0, 0))