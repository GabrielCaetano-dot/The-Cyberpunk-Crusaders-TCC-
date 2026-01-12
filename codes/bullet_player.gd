extends Area

var speed: float = 50.0
var damageAmount = 1
var direction: Vector3 = Vector3.ZERO
var dir_x = 0

func _ready():
	pass

func _process(delta: float) -> void:
	direction.x = dir_x 
	translate(direction * speed * delta)

func _on_Area_body_entered(body):
	if body != self:
		body.takeDamage(damageAmount)
		queue_free()
