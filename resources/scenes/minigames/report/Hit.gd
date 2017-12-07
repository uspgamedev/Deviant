extends Sprite

onready var text = get_node("../Doc")

var SPEED = 100

var _trail
var pin

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var last_pos = get_pos()
	if pin:
		var pin_pos = pin.get_pos()
		if last_pos.distance_squared_to(pin_pos) > 300 and pin_pos.y - last_pos.y < 0:
			set_modulate(Color(0.5, 0.5, 0.5))
	set_pos(last_pos + Vector2(0, 100*delta))
	if (get_pos().y > 400):
		queue_free()

func set_info(letter, trail):
	get_node("Label").set_text(letter)
	_trail = trail
	pin = get_node("../Pin"+str(trail))

func _check_hit():
	if get_pos().distance_squared_to(pin.get_pos()-Vector2(0, 10)) < 300:
		text.add_text(get_node("Label").get_text())
		queue_free()
