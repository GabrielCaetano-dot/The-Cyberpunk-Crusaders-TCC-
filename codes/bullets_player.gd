extends RigidBody
onready var bullet = NodePath()
class_name Tronco
enum {nog, pog}
var speed:= 25
var damageAmount = 1
var direction: Vector3 = Vector3.ZERO
var stop = 0
var state = pog
onready var timer = $Timer

func _ready():
	gravity_scale = 0
	
func _process(delta: float) -> void:
	match state:
		pog:
			translation += transform.basis * Vector3(0, 0, speed)* delta
		nog:
			gravity_scale = -0.5

func _on_Area_body_entered(body):
	if body != self:
		body.takeDamage(damageAmount)
		queue_free()

func stop():
	state = nog
	timer.start()
	
func limpar():
	timer.stop()
	queue_free()

func _on_Timer_timeout():
	limpar()

