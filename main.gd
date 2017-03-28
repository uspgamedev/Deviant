
extends Panel

const Face1 = preload("res://images/FirstCharFace.jpg")

func _ready():
	set_fixed_process(true)
	get_node("FaceView1").set_texture(Face1)
	pass
	
func _fixed_process(delta):
	pass