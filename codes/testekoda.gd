extends KinematicBody

export var player = NodePath()
const bullet = preload("res://obj/bullets_player.tscn")
const bullets = preload("res://codes/bullets_player.gd")

onready var model:Spatial = $kodaani
onready var timer = $Timer 
onready var shoot = $shoot
onready var jump = $Jumping
onready var da= $DASH
onready var sho = $SHOT
onready var morte = $morte
onready var chuchu = $chute
export var maxHealth = 50
enum {idle, run, act, roll, att, dead}
var state = idle
var val = 0.2
var velocity: Vector3 = Vector3.ZERO
var speed = 5
var JUMP_VELOCITY = 7.5
var currentHealth = 3
var damageAmount = 1
var dano = 2
var time = 0.0
var kick = 0.7
var can_jump = true
var can_shoot = true
var can_dash = true
var can_kick = true
var dashing = false
var desvio = false
var facing = true
var move = false
var state_machine 

func _ready():
	print(currentHealth)
	#$hit/dan.disabled = true
	#$kodaani/Armature/Skeleton/BoneAttachment.visible = false
func _physics_process(delta): 
	state_machine = $kodaani/AnimationTree.get('parameters/playback')
	move(delta)
	jump(delta)
	dash()
	kick()
	shoot()
	move_and_slide(velocity)
	#print(state)

func move(delta):
	velocity.x = 0
	if Input.is_action_pressed("right"):
		move = true
		velocity.x = speed
		facing = true
		model.rotation.y = -4.8
		#$hit.rotation.y = -90
		#$hit.translation.x = 1.4
		#$hit.translation.z = -0.642
		state_machine.travel('Run-loop')
		if sign($arma.translation.x) == -1:
			$arma.translation.x *= -1

	if Input.is_action_pressed("left"):
		move = true
		velocity.x = -speed
		facing = false
		model.rotation.y = 4.8
		#$hit.rotation.y = 90
		#$hit.translation.x = -0.7
		#$hit.translation.z = 0.642
		state_machine.travel('Run-loop')
		if sign($arma.translation.x) == 1:
			$arma.translation.x *= -1
	if dashing == true:
		state_machine.travel("Roll-loop")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state = run
	else:
		state = idle

func jump(delta):
	if Input.is_action_just_pressed("jump") and can_jump == true:
		state_machine.travel('NewJump-loop')
		velocity.y = JUMP_VELOCITY
		state = act
		can_jump = false
		jump.start()

func dash():
	if Input.is_action_just_pressed("down") and dashing == false and $Stamina.value >= 80:
		state = roll

func shoot():
	if Input.is_action_just_pressed("fire") and can_shoot == true: #and $Gun.value >= 160:
		var gun = bullet.instance()
		get_parent().add_child(gun)
		gun.translation = $arma.global_translation
		if state == idle:
			state_machine.travel('Shoot-loop')
		if state == run:
			state_machine.travel('Shoot Run-loop')
		if facing == false:
			gun.speed = -15
		can_shoot = false
		#$Gun.value -= 40
		#$Gun.val = false
		sho.start()
		shoot.start()

func dont_move():
	if Input.is_action_pressed("right"):
		move = true
		velocity.x = 0
		facing = true
	if Input.is_action_pressed("left"):
		move = true
		velocity.x = 0
		facing = false
		model.rotation.y = 4.8

func kick():
	if Input.is_action_just_pressed("kick") and can_kick == true:
		state_machine.travel("Kick-loop")
		#$hit/dan.disabled = false
		state = att
		can_kick = false
		chuchu.start()
		speed = 0

func takeDamage(damageAmount):
	if desvio == false:
		currentHealth -= damageAmount
		#$Vida.value -= currentHealth * 21
		if currentHealth <= 0:
			pause_mode
			morte.start()

func die():
	queue_free()
	get_tree().change_scene("res://menus/death.tscn")

func _on_Timer_timeout():
	desvio = false
	dashing = false
	speed = 5
	state = idle

func _on_shoot_timeout():
	can_shoot = true 

func _on_Jumping_timeout():
	jump.stop()
	state = idle
	can_jump = true

func _on_DASH_timeout():
	pass
	#$Stamina.val = true

func _on_SHOT_timeout():
	pass
	#$Gun.val = true

func _on_morte_timeout():
	state = dead

func _on_hit_body_entered(body, delta):
	print("io")
	body.takeDamage(dano)
	body.dash(delta)
	#$hit/dan.disabled = true

func _on_chute_timeout():
	speed = 5
	state = idle
	can_kick =true


func _on_dano_timeout():
	pass # Replace with function body.
