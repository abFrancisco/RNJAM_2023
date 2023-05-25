extends Control

@onready var global = get_node("/root/Global")

func _ready():
	global.score = 0
	global.time = 0
	global.player_color = Color.WHITE
	global.hat = ""
	$MarginContainer/VBoxContainer/Randomize.grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_randomize_pressed():
	$MarginContainer/VBoxContainer/TextureRect.modulate = global.randomize_player_color()
	global.randomize_hat()
