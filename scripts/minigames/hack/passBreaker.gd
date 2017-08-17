extends Control

export var diff = 1

const cons = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
			  "n", "p", "q", "r", "s", "t", "v", "w", "x", "y",
			  "z"]
const vogs = ["a", "e", "i", "o", "u"]
const nums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
const all = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
			 "n", "p", "q", "r", "s", "t", "v", "w", "x", "y",
			 "z", "0", "1", "2", "3", "4", "5", "6", "7", "8",
			 "9", "a", "e", "i", "o", "u"]
const ks = [0.6, 0.34, 0.21]

var Log
var Time
var Hints
var fields = []

var prob = 0
var tries = 0
var wasPressed = false
var phase = 0
var passwd = ""
var victory = false

signal ended

func _ready():
	var v = 0
	var c = 0
	var n = 0
	Time = get_node("Timer")
	Log = get_node("Label")
	Hints = get_node("Hints")
	randomize()
	for i in range(6):
		passwd += all[randi()%36]
		if passwd[i] in vogs:
			v += 1
		elif passwd[i] in nums:
			n += 1
		else:
			c += 1
	Hints.set_text("V: " + str(v) + "       C: " + str(c) + "       N: " + str(n))
	for i in range(1, 7):
		fields.append(get_node("LineEdit"+str(i)))
	init(1)
	set_fixed_process(true)

func init(d):
	diff = d

func _fixed_process(delta):
	if (Input.is_action_pressed("submit_pass") and not wasPressed):
		_on_passwd_submit()
		wasPressed = true
	elif (not Input.is_action_pressed("submit_pass")):
		wasPressed = false
	if phase == 1:
		Log.set_text(str(int(Time.get_time_left())))

func same_group(char1, char2):
	if (char1 in cons) and (char2 in cons):
		return true
	elif (char1 in vogs) and (char2 in vogs):
		return true
	elif (char1 in nums) and (char2 in nums):
		return true
	return false

func _on_passwd_submit():
	if phase == -1:
		return
	for i in range(6):
		if (fields[i].get_text() == passwd[i]):
			fields[i].get_node("Polygon2D").set_color(Color(0.0, 1.0, 0.0))
			fields[i].set_editable(false)
		elif (fields[i].get_text() in passwd):
			fields[i].get_node("Polygon2D").set_color(Color(1.0, 1.0, 0.0))
		elif (same_group(passwd[i], fields[i].get_text())):
			fields[i].get_node("Polygon2D").set_color(Color(0.0, 0.0, 1.0))
		else:
			fields[i].get_node("Polygon2D").set_color(Color(1.0, 0.0, 0.0))
	if phase == 0:
		prob += 1/(1+exp(ks[diff]*(9.8-tries)))
		tries += 1
		var rand = randf()
		if rand < prob:
			print(rand)
			Log.set_text("")
			get_parent().log_append(" -- Você foi descoberto!!")
			rand = get_chi_squared_rand()
			Time.set_wait_time(180-rand-diff)
			get_parent().log_append(" -- Você tem " + str(int(180-rand-diff)) + "s")
			get_parent().log_append("até que fechem a conexão!!")
			Time.start()
			phase = 1
		else:
			Log.set_text("Probabilidade: " + str(int(prob*100)) + "%")
		print(rand)
	if check_win():
		phase = -1
		Log.set_text("")
		get_parent().log_append(" -- Você conseguiu :)")
		Time.stop()
		emit_signal("ended")

func get_chi_squared_rand():
	var ret = 1
	for i in range(diff):
		ret *= randf()
	print(-2*log(ret))
	ret = min(20, -2*log(ret))
	return ret

func _on_Timer_timeout():
	phase = -1
	for i in range(6):
		fields[i].set_editable(false)
	Time.stop()
	Log.set_text("Game Over")
	get_parent().log_append(" -- Você não conseguiu :(")
	print(passwd)
	emit_signal("ended")

func _on_LineEdit_text_changed( text, num ):
	if (text.length() == 2):
		if (fields[num].get_cursor_pos() == 1):
			fields[num].set_text(text[0])
		else:
			fields[num].set_text(text[1])
		fields[num].set_cursor_pos(1)

func check_win():
	for i in range(6):
		if fields[i].get_text() != passwd[i]:
			return false
	victory = true
	return true
