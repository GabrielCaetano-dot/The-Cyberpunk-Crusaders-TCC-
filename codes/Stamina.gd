extends TextureProgress
var speed = 0.3
var val = false
func _ready():
	 pass

func _process(delta):
	if value <210 and val == true:
		value += 0.5 *speed
