extends Control



func _ready():
	pass

func _on_start_pressed():
	get_node("Anim").play("Dim")
	yield(get_node("Anim"), "finished")
	get_tree().change_scene("res://resources/scenes/main.tscn")
