extends KinematicBody
class_name enemies
onready var agent: NavigationAgent = $NavigationAgent
onready var player = get_node('/root/mundo/Player')
onready var mundo = get_node('/root/mundo')
#onready var energia = preload("res://obj/Energia.tscn")
onready var model = $Pugilista
onready var eixo = $eixo
var zero = 0
var move_direction = Vector3(1, 0, 0)
var hp = 5
var speed = 5
var r = 3
var cooldown = 1.4
var timer = 0.0
var damageAmount = 1
var che = 0
enum {idle, move}
var state = move
var sair = 0
var state_machine
func _ready():
	pass
func _physics_process(delta):
	match state:
		idle:
			speed = 0
			timer = 0.0
			visible = false
		move:
			state_machine = $Pugilista/AnimationTree.get('parameters/playback')
			if agent.is_navigation_finished():
				return
			var distance = global_transform.origin.distance_to(player.translation)
			if distance >= r:
				che = 0
				var direction = (player.global_transform.origin - global_transform.origin).normalized()
				var movement = move_direction * direction * speed * delta
				state_machine.travel('Run-loop')
				move_and_collide(movement)
			if global_transform.origin.distance_to(player.global_transform.origin) <= r:
				che = 1
				timer += delta
				state_machine.travel('Punch-loop')
				if timer >= cooldown and che == 1:
					timer = 0.0
					_on_timer_timeout()
			var giro = eixo.global_transform.origin - player.global_transform.origin
			if giro.x < zero:
				model.rotation.y = 1.5
			if giro.x > zero:
				model.rotation.y = -1.5
	if mundo.morra == 1:
		self.takeDamage(5)
func takeDamage(damageAmount):
	print ("ai")
	hp -= damageAmount
	if hp <= 0:
		#drop()
		player.get_node("Gun").value += 80
		queue_free()

#func drop():
#	var eneg = energia.instance()
#	get_parent().add_child(eneg)
#	eneg.translation = $spawn.global_translation

func _on_timer_timeout(): 
	player.takeDamage(damageAmount)

func _on_Area_body_entered(body):
	if body == RigidBody:
		self.takeDamage(damageAmount)
