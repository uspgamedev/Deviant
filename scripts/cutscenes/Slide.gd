extends Sprite

var frame = 0

func _ready():
	pass
	
func specFunc():
	frame += 1
	set_frame(frame)
