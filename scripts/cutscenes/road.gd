extends Spatial

const Road = preload("res://resources/assets/images/Road_test.tex")
const Building = preload("res://resources/assets/images/Building.tex")
const Sign = [preload("res://resources/assets/images/GodotSign.tex"),
			  preload("res://resources/assets/images/UGDSign.tex"),
			  preload("res://resources/assets/images/GTWSign.tex"),
			  preload("res://resources/assets/images/GTDSign.tex"),
			  preload("res://resources/assets/images/GTCSign.tex")]

const FRAME = Rect2(Vector2(374, 653), Vector2(700, 1000))
const NUM_OF_ROADS = 15

var Cam
var Roads = []
var Builds = [[], []]
var Signs = []
var last = 0
var last2 = 0
var count = 0
var count2 = 0

func _ready():
	Cam = get_node("Camera")
	var pos = Vector3(0, 0, 0)
	var pos2 = Vector3(3.5, 3.9, -3.6)
	var pos3 = Vector3(-1, 2, 50)
	for i in range(NUM_OF_ROADS):
		Roads.append(new_road(pos))
		add_child(Roads[i])
		pos.z += 9.8
	for i in range(3*NUM_OF_ROADS):
		for j in range(2):
			Builds[j].append(new_build(pos2))
			add_child(Builds[j][i])
			pos2.x = -pos2.x
		pos2.z += 3.6
	for i in range(5):
		Signs.append(new_sign(i, pos3))
		add_child(Signs[i])
		pos3.z += 20
	count = pos.z
	count2 = pos2.z
	set_fixed_process(true)
	
func new_road(pos):
	var road = Sprite3D.new()
	road.set_translation(pos)
	road.set_texture(Road)
	road.set_region_rect(FRAME)
	road.set_region(true)
	road.set_axis(1)
	return road
	
func new_build(pos):
	var build = Sprite3D.new()
	build.set_translation(pos)
	build.set_texture(Building)
	build.set_axis(0)
	build.set_scale(Vector3(2, 2, 2))
	return build
	
func new_sign(i, pos):
	var s = Sprite3D.new()
	s.set_translation(pos)
	s.set_texture(Sign[i])
	s.set_rotation(Vector3(0, 3.14, 0))
	return s

func _fixed_process(delta):
	var orig = Cam.get_translation()
	orig.z += 0.1
	Cam.set_translation(orig)
	if (Roads[last].get_translation().z + 4.9 < orig.z):
		var pos = Roads[last].get_translation()
		pos.z = count
		Roads[last].set_translation(pos)
		last = (last + 1)%NUM_OF_ROADS
		count += 9.8
	if (Builds[0][last2].get_translation().z + 3.6 < orig.z):
		var pos = Builds[0][last2].get_translation()
		pos.z = count2
		Builds[0][last2].set_translation(pos)
		pos.x = -pos.x
		Builds[1][last2].set_translation(pos)
		last2 = (last2 + 1)%(3*NUM_OF_ROADS)
		count2 += 3.6
