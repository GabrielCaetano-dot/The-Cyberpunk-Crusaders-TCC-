extends Node
var vil =false
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("pausar") and vil == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		$UI/menu.visible = true
		$UI/menu/
		#$Player/Stamina.visible = false
		#$Player/Gun.visible = false
		#$Player/Vida.visible = false
		vil = true
	elif Input.is_action_just_pressed("pausar")and vil == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		$UI/menu.visible = false
		#$Player/Stamina.visible = true
		#$Player/Gun.visible = true
		#$Player/Vida.visible = true
		vil = false
