extends RigidBody

var damageAmount = 2
var direction = Vector3(1,0,0)

func _ready():
	gravity_scale = 0

func _on_Area_body_entered(body):
	if body != self:
		body.takeDamage(damageAmount)
		queue_free()
