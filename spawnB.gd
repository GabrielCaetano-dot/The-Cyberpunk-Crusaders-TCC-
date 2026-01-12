extends Position3D
onready var bombardeiro = preload("res://enemies/bomber.tscn")
onready var timer = 0.0
enum {no, work}
var state = work
var sair = 1
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if sair == 0:
		state = no
	if sair == 1:
		state = work
	match state:
		no:
			pass
		work:
			timer += delta
			if timer >= 34:
				timer = 0.0
				print("nasco")
				var enemy = bombardeiro.instance()
				get_parent().add_child(enemy)
				enemy.translation = global_translation 
