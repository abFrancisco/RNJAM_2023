extends Control

@export var world: CharacterBody2D = null

func toggle():
	
	var tween = get_tree().create_tween()
	if visible:
		hide()
		$MarginContainer/VBoxContainer/Continue.release_focus()
		get_tree().paused = false
	else:
		show()
		$MarginContainer/VBoxContainer/Continue.grab_focus()
		get_tree().paused = true


func _on_continue_pressed():
	toggle()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
