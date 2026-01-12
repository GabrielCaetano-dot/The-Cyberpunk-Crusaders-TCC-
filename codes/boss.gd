extends KinematicBody
class_name bossal
export var path = NodePath()
onready var agent: NavigationAgent = $NavigationAgent
onready var player = get_node('/root/mundo/Player')
onready var pistola = preload("res://obj/pistola.tscn")
onready var projetil = preload("res://obj/sniper.tscn")
onready var invisivel = $Invisible
onready var cego = $Invislbilidade
onready var skill = $Tempo/skill
onready var model = $Sicarius
onready var eixo = $eixo
var move_direction = Vector3(1, 0, 0)
var zero = 0
var relo = 0.0
var bola = 5
var ola = 3
var spider = 2
var visivel = 4
enum {parado, ranged, melee, sniper}
var projetil_speed: float = 30.0
var sniper_speed = 50
var hp = 15
var speed
var r = 3
var r_r = 15
var cooldown = 1.0
var cooldown_r = 2.0
var cooldown_s = 4
var timer = 0.0
var timert = 0.0
var tri = 0.0
var damageAmount = 1
var state = parado
var stop = 0
var troca = 20
var fugi = 2
var switch = false
var s = true
var b = 1
var a = 1
var i = 1
var sair = 0
var ativo = false
var state_machine

var animao
func _ready():
	pass
func _physics_process(delta):
	state_machine = $Sicarius/AnimationTree.get('parameters/playback')
	if sair == 1:
		state = ranged
	var distance = global_transform.origin.distance_to(player.translation)
	if agent.is_navigation_finished():
		return
	if state == ranged:
		ativo = true
	var giro = eixo.global_transform.origin - player.global_transform.origin
	if giro.x < zero:
		model.rotation.y = 4.8
	if giro.x > zero:
		model.rotation.y = -4.8
	match state:
		parado:
			speed = 0
		ranged:
			if hp == 13:
				sair = 2
				state = melee
			if state == ranged and hp < 13:
				if distance > 16:
					state = sniper
				if distance <= 6:
					state = melee
			speed = 5
			timert += delta 
			if timert >= bola and b == 1:
				print("alou")
				b = 0
				timert = 0.0
			if timert >= bola and b == 0:
				print("tchau")
				b = 1
				timert = 0.0
			timer += delta
			if global_transform.origin.distance_to(player.global_transform.origin) <= r_r: 
				animao = 3
				if timer >= cooldown_r:
					timer = 0.0
					switch = true
					_on_timer_timeout_r()
			if distance >= r_r:
				animao = 1
				_process_movement(delta)
		melee:
			timer += delta
			if timer >= cooldown:
				timer = 0.0
				_on_timer_timeout()
			relo += delta 
			if relo >= 1 and i == 1 and a ==1:
				i = 0
				a = 0
				relo = 0.0
				hide()
			if relo >= 2 and i == 0:
				i = 1
				relo = 0.0
				visible = true
			if relo >= 4 and i == 1 and a == 0:
				i = 0
				relo = 0.0
				hide()
			speed = 6
			timert += delta
			if timert >= troca:
				timert = 0.0
				state = sniper
			if hp == 3:
				state = ranged
			if distance >= r:
				_process_movement(delta)
		sniper:
			_dash(delta)
			if s == false and distance > 6:
				state = ranged
			if s == false and distance <= 6:
				state = melee
			state != melee and ranged
			timer += delta
			if timer >= cooldown_s:
				timer = 0.0
				_on_timer_timeout_s()
	
func state_check():
	var distance = global_transform.origin.distance_to(player.translation)
	if state == sniper:
		if s == false and distance > 6:
			state = ranged
		if s == false and distance <= 6:
			state = melee
	if state == ranged and hp < 13:
		if distance > 24:
			state = sniper
		if distance <= 6:
			state = melee

func takeDamage(damageAmount):
	hp -= damageAmount
	if hp <= 0:
		get_tree().change_scene("res://menus/home.tscn")
		queue_free()

func hide():
	speed = 6
	visible = false
	var distance = global_transform.origin.distance_to(player.translation)
	if distance >= r:
		_process_movement(get_process_delta_time())

func _process_movement(delta: float) -> void:
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	var movement = move_direction * direction * speed * delta
	move_and_collide(movement)

func _dash(delta):
	speed = 15
	var track = (player.global_transform.origin - global_transform.origin).normalized()
	var movement = move_direction * track * (-speed) * delta
	tri += delta
	if tri >= fugi:
		speed = 0
		movement = move_direction * track * stop * delta
	move_and_collide(movement)
 
func _on_timer_timeout(): 
	if global_transform.origin.distance_to(player.global_transform.origin) <= r: 
		player.takeDamage(damageAmount)

func _on_timer_timeout_r(): 
	var new_projetil = pistola.instance()
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	new_projetil.linear_velocity = move_direction * direction * projetil_speed
	get_parent().add_child(new_projetil)
	new_projetil.translation = $mira.global_translation 

func _on_timer_timeout_s():
	var new_projetil = projetil.instance()
	new_projetil.own = self
	var direction = (player.koda.global_transform.origin - global_transform.origin).normalized()
	new_projetil.linear_velocity = move_direction * direction * sniper_speed
	get_parent().add_child(new_projetil)
	new_projetil.translation = $mira.global_translation 

func _on_Invislbilidade_timeout():
	visible = true
	if state == melee:
		invisivel.start()

func _on_Tempo_body_entered(body):
	if body != self:
		body.stop()

func _on_Invisible_timeout(delta):
	invisivel.stop(delta)
	hide()
	print ("agora vc me vê, agora n vê mais!")
	cego.start()

