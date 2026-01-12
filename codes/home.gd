extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_new_game_pressed():
	get_tree().change_scene("res://mundo.tscn")

func _on_continue_pressed():
	get_tree().change_scene("res://mundo.tscn")

func _on_exit_pressed():
	get_tree().quit()
