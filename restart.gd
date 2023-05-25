extends Control

@export var player: CharacterBody2D = null

func toggle():
	var tween = get_tree().create_tween()
	if visible:
		hide()
		$MarginContainer/VBoxContainer/Respawn.release_focus()
	else:
		show()
		$MarginContainer/VBoxContainer/Respawn.grab_focus()

func _on_respawn_pressed():
	player.respawn()
	toggle()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
