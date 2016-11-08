
extends Control

func _ready():
	pass
	
func draw_core():
	update()

func _draw():
	draw_circle(Vector2(20, 20), 20, Color("Black"))
	


