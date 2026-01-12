extends Area

func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if body is Player:
		body.get_node("Gun").value += 40
		queue_free()
