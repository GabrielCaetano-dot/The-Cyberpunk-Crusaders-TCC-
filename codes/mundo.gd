extends Spatial
onready var labs = $Navigation/NavigationMeshInstance/Area
onready var lab = $Navigation/NavigationMeshInstance/LAB3
onready var mf = $fase
onready var mb = $boss
onready var run = $run
onready var chefe = preload("res://enemies/boss.tscn")
onready var player = get_node("/root/mundo/Player") 
onready var boss = get_node("/root/mundo/boss2") 
onready var pugis = get_node("/root/mundo/enemy")
onready var atis = get_node("/root/mundo/enemy_gun")
var speed = 2.5
var final = false
var vil = false
var musica = 0.0
var breakcore = 4
var vo = false
var morra
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$spawnP2.sair = 0
	$Node/UI/menu.visible = false

func _physics_process(delta):
	if player.morto == true:
		$sala1.visible = false
		$sala2.visible = false
		$sala3.visible = false
		$sala4.visible = false
	
func _on_luz_timeout():
	$luz.stop()
	$sala1.visible = false
	$sala2.visible = false
	$sala3.visible = false
	$sala4.visible = false
	$luzinha.start()

func _on_luzinha_timeout():
	$luzinha.stop()
	$sala1.visible = true
	$sala2.visible = true
	$sala3.visible = true
	$sala4.visible = true
	$luiz.start()

func _on_luiz_timeout():
	$luiz.stop()
	$sala1.visible = false
	$sala2.visible = false
	$sala3.visible = false
	$sala4.visible = false
	$light.start()
	
func _on_light_timeout():
	$light.stop()
	$sala1.visible = true
	$sala2.visible = true
	$sala3.visible = true
	$sala4.visible = true
	$luz.start()

func _on_Timer_timeout():
	$Navigation/NavigationMeshInstance/StaticBody/saida.disabled = false

func _on_nasso_timeout():
	$musi.stop()
	$boss.playing = true

func _on_portinha_area_entered(area):
	if area == $Player/Area2:
		print("foi")
		$spawnP.sair = 0
		$spawnP2.sair = 1

func _on_porta_body_entered(body):
	if body == $Player:
		$fase.playing = false
		$musi.start()
		morra = 1
		$spawnA.sair = 0
		$spawnB.sair = 0
		$spawnP2.sair = 0
		labs.visible = false
		lab.visible = true
		$Timer.start()
		boss.sair = 1
		$porta.queue_free()
