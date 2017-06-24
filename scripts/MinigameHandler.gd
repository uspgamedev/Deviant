extends Control

const FF = preload("res://resources/scenes/minigames/flowfree/flowfreeCanvas.xscn")
const PB = preload("res://resources/scenes/minigames/flowfree/passBreaker.tscn")

var running = null
var ins = null

signal ended

func _ready():
	#run_minigame("flowfree", null)
	pass

func run_minigame(name, params):
	if is_running():
		return
	if name == "flowfree":
		running = "flowfree"
		ins = FF.instance()
		add_child(ins)
	elif name == "passBreaker":
		running = "passBreaker"
		ins = PB.instance()
		add_child(ins)
	yield(ins, "ended")
	emit_signal("ended")

func is_running():
	return running != null

func get_running():
	return running

func game_close():
	ins.queue_free()
	ins = null
	running = null
	