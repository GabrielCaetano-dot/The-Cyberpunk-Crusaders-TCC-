extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _on_restart_pressed():
	get_tree().change_scene("res://mundo.tscn")

func _on_return_pressed():
	get_tree().change_scene("res://menus/home.tscn")
