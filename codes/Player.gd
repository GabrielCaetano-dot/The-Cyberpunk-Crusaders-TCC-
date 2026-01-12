extends KinematicBody
class_name Player

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const bullet = preload("res://obj/bullets_player.tscn")
const bullets = preload("res://codes/bullets_player.gd")
onready var koda = $koda
onready var model:Spatial = $kodaani
onready var timer = $Timer 
onready var shoot = $shoot
onready var jump = $Jumping
onready var da= $DASH
onready var sho = $SHOT
onready var morte = $morte
onready var atira = $atis
onready var chuchu = $chute
export var maxHealth = 5
enum {idle, run, act, roll, att}
var state = idle
var val = 0.2
var velocity: Vector3 = Vector3.ZERO
var speed = 5
var JUMP_VELOCITY = 7.5
var currentHealth = 5
var damageAmount = 1
var dano = 3
var time = 0.0
var kick = 0.0
var can_jump = true
var can_shoot = true
var can_dash = true
var can_kick = true
var dashing = false
var desvio = false
var facing = true
var move = false
var r = 3
var tempo = 0.0
var chute = 1
var subi = 0.7
var state_machine
var morto = false

func _physics_process(delta): 
	state_machine = $kodaani/AnimationTree.get('parameters/playback')
	if state == idle:
		can_kick = true
	if state != act:
		velocity.y = 0
	match state:
		idle:
			state_machine.travel('Idle-loop')
			move(delta)
			jump(delta)
			dash()
			shoot()
			kick(delta)
		run:
			move(delta)
			jump(delta)
			dash()
			kick(delta)
			shoot()
		act:
			jump(delta)
			time += delta
			if time >= subi:
				time = 0.0
				velocity.y = -7.5
				$desce.start(delta)
		roll:
			speed = speed * 2.8
			desvio = true
			$Stamina.value -= 30
			$Stamina.val = false
			$CollisionShape.disabled = true
			da.start()
			timer.start()
			move(delta)
		att:
			state_machine.travel("Kick-loop")
			dont_move()
			tempo += delta
			if tempo >= 1:
				tempo = 0.0 
				_on_chute_timeout()
			kick += delta
			if kick >= 1:
				kick = 0.0
				_on_DASH_timeout()
	move_and_slide(velocity)

func move(delta):
	velocity.x = 0
	if Input.is_action_pressed("right"):
		move = true
		velocity.x = speed
		facing = true
		model.rotation.y = -4.8
		$Area/CollisionShape.translation.x = 0
		state_machine.travel('Run-loop')
		if sign($arma.translation.x) == -1:
			$arma.translation.x *= -1

	if Input.is_action_pressed("left"):
		move = true
		velocity.x = -speed
		facing = false
		model.rotation.y = 4.8
		$Area/CollisionShape.translation.x = -0.5
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
		can_shoot = false
		dashing = true
func shoot():
	if Input.is_action_just_pressed("fire") and can_shoot == true and $Gun.value >= 160:
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
		$Gun.value -= 40
		$Gun.val = false
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

func takeDamage(damageAmount):
	if desvio == false:
		currentHealth -= damageAmount
		if damageAmount == 1:
			$Vida.value -= 13
		if damageAmount == 2:
			 $Vida.value -= 26
		if damageAmount == 5:
			 $Vida.value -= 80
		if currentHealth <= 0:
			die()

func kick(delta):
	if Input.is_action_just_pressed("kick") and can_kick == true and $Stamina.value >= 80:
		$Stamina.value -= 30
		$Stamina.val = false
		$Area/CollisionShape.disabled = false
		state = att
		can_kick = false

func die():
	morto = true
	speed = 0
	visible = false
	state_machine.travel('Die-loop')
	$morte.start()

func _on_Timer_timeout():
	desvio = false
	dashing = false
	can_shoot = true
	$CollisionShape.disabled = false
	speed = 5
	state = idle

func _on_shoot_timeout():
	can_shoot = true 
	
func _on_Jumping_timeout():
	jump.stop()
	state = idle
	can_jump = true

func _on_DASH_timeout():
	$Stamina.val = true

func _on_SHOT_timeout():
	$Gun.val = true

func _on_chute_timeout():
	print("oi")
	chuchu.stop()
	can_kick = true
	state = idle

func _on_morte_timeout():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene("res://menus/death.tscn")

func _on_desce_timeout():
	$desce.stop()
	velocity.y = -7.5

func _on_Area_body_entered(body):
	body.takeDamage(dano) 
	$Area/CollisionShape.disabled = true
