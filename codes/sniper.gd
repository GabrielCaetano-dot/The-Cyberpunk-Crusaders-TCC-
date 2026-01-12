extends RigidBody
onready var player = get_node("/root/mundo/Player")
var damageAmount = 1
var direction = Vector3(1,0,0)
var own

func _ready():
	gravity_scale = 0

func _on_Area_body_entered(body):
	if body != self:
		own.s = false
		player.desvio = false
		body.takeDamage(damageAmount)
		queue_free()

