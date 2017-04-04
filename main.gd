
extends Panel

const Face1 = preload("res://images/FirstCharFace.jpg")

func _ready():
	get_node("FaceView1").set_texture(Face1)
	var sceene = parse_sceene("test")
	print(sceene[0]["Panel_1"])
	print(sceene[1]["Panel_2"])
	set_fixed_process(true)
	pass
	
func parse_sceene(name):
	var dict = {}
	var file = File.new()
	file.open("res://" + name + ".json", file.READ)
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	return dict[name]

func _fixed_process(delta):
	pass