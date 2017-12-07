extends Node2D

const Hit = preload("res://resources/scenes/minigames/report/Hit.tscn")
const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
const Help = "Use as teclas 'D', 'F', 'J' e 'K' para jogar.\nCada tecla corresponde à um círculo colorido.\nPara escrever o relatório aperte a tecla\ncorrespondente para acertar os círculos brancos."

signal red
signal green
signal blue
signal yellow

var colors = ["red", "green", "blue", "yellow"]
var keys = [KEY_D, KEY_F, KEY_J, KEY_K]

var Pins = []
var Time

func _ready():
	Time = get_node("Timer")
	for i in range(4):
		Pins.append(get_node("Pin" + str(i)))
	start_map(0)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY:
		for i in range(4):
			var input = Input.is_key_pressed(keys[i])
			if Pins[i].frame != input and input:
				emit_signal(colors[i])
			Pins[i].frame = input
		
func start_map(num):
	var ctr = 1
	var t = 0
	while (ctr < 50):
		var new_hit = Hit.instance()
		var rail = randi()%4
		new_hit.set_pos(Vector2(158 + 50*rail, 0))
		self.connect(colors[rail], new_hit, "_check_hit")
		add_child(new_hit)
		new_hit.set_info(chars[randi()%chars.length()], rail)
		Time.set_wait_time(randf()*0.8+0.7)
		Time.start()
		yield(Time, "timeout")
		ctr += 1
	Time.set_wait_time(5)
	Time.start()
	yield(Time, "timeout")
	print("usgdgfgsdufguysdgfyu")

func _on_Button_pressed():
	var HD = get_node("HelpDialog")
	HD.set_pos(Vector2(120, 100))
	HD.set_text(Help)
	HD.popup()
	get_tree().set_pause(true)

func _on_HelpDialog_confirmed():
	get_tree().set_pause(false)
