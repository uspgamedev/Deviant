extends Control

var hasMail = false

func _ready():
	pass

func recieveMail():
	hasMail = true
	get_node("Sprite").set_frame(1)
	get_node("Anim").play("shake")

func _on_Button_pressed():
	if hasMail:
		get_node("Anim").stop()
		get_parent().get_parent().run_item_func("", "changeScene", ["MeetingRoom"], null)
