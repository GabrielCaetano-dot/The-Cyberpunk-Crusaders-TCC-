extends KinematicBody
export var path = NodePath()
onready var model = $atirador
onready var mundo = get_node('/root/mundo')
onready var agent: NavigationAgent = $NavigationAgent
onready var player = get_node('/root/mundo/Player')
onready var projetil = preload("res://obj/bullets.tscn")
onready var eixo = $eixo

var move_direction = Vector3(1, 0, 0)
enum {idle, move}
var projetil_speed: float = 30.0
var hp = 3
var speed = 4
var r = 10
var cooldown = 1.5
var timer = 0.0
var damageAmount = 1
var stop = 0
var state_machine
var state = move
var sair = 0

func _ready():
	pass

func _physics_process(delta: float) -> void:
	match state:
		idle:
			speed = stop
			timer = 0.0
		move:
			state_machine = $atirador/AnimationTree.get('parameters/playback')
			var giro = eixo.global_transform.origin - player.global_transform.origin
			var distance = global_transform.origin.distance_to(player.translation)
			if agent.is_navigation_finished():
				return
			if distance >= r:
				var direction = (player.global_transform.origin - global_transform.origin).normalized()
				var movement = move_direction * direction * speed * delta
				state_machine.travel('Walking-loop')
				if giro.x > stop:
					model.rotation.y = 4.5
				if giro.x < stop:
					model.rotation.y = -4.3
				move_and_collide(movement)
			timer += delta
			if timer >= cooldown and global_transform.origin.distance_to(player.global_transform.origin) <= r:
				state_machine.travel('Shooting-loop')
				timer = 0.0
				_on_timer_timeout()
				if giro.x > stop:
					model.rotation.y = -3
					$mira.translation.x = -1
				if giro.x < stop:
					model.rotation.y = 0
					$mira.translation.x = 1
	if mundo.morra == 1:
		takeDamage(3)

func takeDamage(damageAmount):
	print ("morri")
	hp -= damageAmount
	if hp <= 0:
		player.get_node("Gun").value += 80
		queue_free()

func _on_timer_timeout(): 
	var new_projetil = projetil.instance()
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	new_projetil.linear_velocity = move_direction * direction * projetil_speed
	get_parent().add_child(new_projetil)
	new_projetil.translation = $mira.global_translation 

func _on_dano_body_entered(body):
	if body == Area:
		self.takeDamage(damageAmount)
