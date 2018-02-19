extends Node2D

const Hit = preload("res://resources/scenes/minigames/report/Hit.tscn")
const PB = preload("res://resources/scenes/minigames/hack/mainCanvas.tscn")
const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
const Help = "Use as teclas 'D', 'F', 'J' e 'K' para jogar.\nCada tecla corresponde à um círculo colorido.\nPara escrever o relatório aperte a tecla\ncorrespondente para acertar os círculos brancos."
const WinLog = "Você conseguiu escrever o relatório a tempo :D\nQuer tentar hackear Roberto para deletar o relatório dele?"
const LoseLog = "Você não conseguiu escrever o relatório a tempo D:\nQuer tentar hackear Roberto para copiar o relatório dele?"

onready var HelpDialog = get_node("HelpDialog")
onready var HackDialog = get_node("HackDialog")
onready var Time = get_node("Timer")

signal red
signal green
signal blue
signal yellow

var colors = ["red", "green", "blue", "yellow"]
var keys = [KEY_D, KEY_F, KEY_J, KEY_K]
var won

var Pins = []
var Cancel

func _ready():
	for i in range(4):
		Pins.append(get_node("Pin" + str(i)))
	Cancel = HackDialog.get_cancel()
	Cancel.connect("pressed", self, "_on_Cancel_pressed")
	randomize()
	start_map()
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY:
		for i in range(4):
			var input = Input.is_key_pressed(keys[i])
			if Pins[i].frame != input and input:
				emit_signal(colors[i])
			Pins[i].frame = input
		
func start_map():
	var ctr = 1
	var t = 0
	Time.set_wait_time(2)
	Time.start()
	yield(Time, "timeout")
	_on_Button_pressed()
	Time.set_wait_time(3)
	Time.start()
	yield(Time, "timeout")
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
	var HD = get_node("HackDialog")
	if get_node("Doc").get_text().length() < 40:
		won = false
		HackDialog.set_pos(Vector2(120, 100))
		HackDialog.set_text(LoseLog)
		HackDialog.popup()
	else:
		won = true
		HackDialog.set_pos(Vector2(120, 100))
		HackDialog.set_text(WinLog)
		HackDialog.popup()

func _on_Button_pressed():
	HelpDialog.set_pos(Vector2(120, 100))
	HelpDialog.set_text(Help)
	HelpDialog.popup()
	get_tree().set_pause(true)

func _on_HelpDialog_confirmed():
	get_tree().set_pause(false)

func _on_Cancel_pressed():
	var p = get_node("../../../")
	p.change_dialogue("Rafael", "Rafael_after_report_bad")
	var num
	var num2
	for i in range(p.SCENES["Workroom"]["Items"].size()):
		if p.SCENES["Workroom"]["Items"][i]["Name"] == "Door2":
			num = i
		if p.SCENES["Workroom"]["Items"][i]["Name"] == "Computer":
			num2 = i
	p.SCENES["Workroom"]["Items"][num]["Args"] = ["MeetingRoom1"]
	p.SCENES["Workroom"]["Items"][num2]["Args"] = [""]
	p.change_scene("Workroom")

func _on_HackDialog_confirmed():
	var newPB = PB.instance()
	newPB.set_pos(Vector2(150, 40))
	newPB.won = won
	var p = get_node("../../")
	p.get_parent().add_child(newPB)
	p.get_parent().Specials[0] = newPB
	p.queue_free()
