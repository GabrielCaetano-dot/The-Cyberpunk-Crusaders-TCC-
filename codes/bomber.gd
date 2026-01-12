extends KinematicBody
export var path = NodePath()
onready var agent: NavigationAgent = $NavigationAgent
onready var player = get_node('/root/mundo/Player')
export var projetil: PackedScene
onready var missel = $Missel
onready var eixo = $eixo
onready var spawn = $spawn
onready var model = $Bomber
enum {idle, move}
var sair = 0
var state = move
var timer = 0.0
var tempo = 0.0
var zero = 0
var projetil_speed = 30
var hp = 2
var r = 300
var e = 5
var damageAmount = 1
var explosao = 5
var move_direction = Vector3(1, 0, 0)
var state_machine

func _ready():
	pass

func _physics_process(delta):
	if sair == 1:
		state = idle
		visible = false
	match state:
		idle:
			timer = 0.0
		move:
			
			state_machine = $Bomber/AnimationTree.get('parameters/playback')
			var distance = global_transform.origin.distance_to(player.translation)
			if distance <= r:
				state_machine.travel('tiro-loop')
			if distance <= e:
				timer += delta
				if timer >= 0.5:
					timer = 1
					player.desvio = false
					player.takeDamage(explosao)
					queue_free()
			var giro = eixo.global_transform.origin - player.global_transform.origin
			if giro.x < zero:
				model.rotation.y = 3
				model.translation.x = -3
				model.translation.z = 0
			if giro.x > zero:
				model.rotation.y = 0
				model.translation.x = 3
				model.translation.z = 0

	
func _on_Missel_timeout():
	var distance = global_transform.origin.distance_to(player.translation)
	var new_projetil = projetil.instance()
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	new_projetil.linear_velocity = move_direction * direction * projetil_speed
	get_parent().add_child(new_projetil)
	new_projetil.translation = $mira.global_translation 
	missel.start()
		
func takeDamage(damageAmount):
	hp -= damageAmount
	if hp <= 0:
		player.get_node("Gun").value += 80
		queue_free()
