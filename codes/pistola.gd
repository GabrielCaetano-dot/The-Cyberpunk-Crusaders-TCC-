extends RigidBody

var damageAmount = 1
var direction = Vector3(1,0,0)
var timer = 0.0
var sair = 3.5

func _ready():
	gravity_scale = 0

func _process(delta):
	timer += delta
	if timer >= sair:
		timer = 0.0
		queue_free()

func _on_Area_body_entered(body):
	if body != self:
		print("doeu mano")
		body.takeDamage(damageAmount)
		queue_free()
