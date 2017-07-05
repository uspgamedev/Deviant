extends Control

var Log
var Wheel

var ini_rot = 0
var mouse_pos = Vector2(0 ,0)
var wheel_pos = Vector2(0 ,0)

func _ready():
	Wheel = get_node("Wheel")
	Log = get_parent().get_node("Log")
	wheel_pos = get_node("Wheel").get_pos()
	set_process_input(true)
	set_fixed_process(true)

func _input(ev):
	var dist = mouse_pos.distance_to(wheel_pos)
	if (ev.is_action_pressed("click_on_character") and dist < 160) or (dist >= 160 and dist <= 170):
		var wheel_rot = Wheel.get_rot()
		ini_rot = wheel_rot - mouse_pos.angle_to_point(wheel_pos)

func _fixed_process(delta):
	mouse_pos = get_viewport().get_mouse_pos()
	if Input.is_action_pressed("click_on_character") and mouse_pos.distance_to(wheel_pos) < 160:
		var new_rot = ini_rot + mouse_pos.angle_to_point(wheel_pos)
		Wheel.set_rot(new_rot)

func _on_Timer_timeout():
	get_parent().run_item_func("", "changeScene", ["Workroom"], null)
	#get_tree().change_scene("res://resources/scenes/road.tscn")

func _on_Wheel_mouse_enter():
	Log.show_text("Volante")

func _on_Radio_mouse_enter():
	Log.show_text("Rádio")

func _on_mouse_exit():
	Log.clear_text()
