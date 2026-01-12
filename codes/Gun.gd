extends TextureProgress
var speed = 0.2
var val = false
func _ready():
	 pass

func _process(delta):
	if value < 370 and val == true:
		value += 0.5 * speed
