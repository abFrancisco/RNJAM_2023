extends Control

@onready var global = get_node("/root/Global")
var player_name: String = ""

func _ready():
	$MarginContainer2/VBoxContainer/TextEdit.grab_focus()

func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		player_name = $MarginContainer2/VBoxContainer/TextEdit.text
		$MarginContainer2/VBoxContainer/TextEdit.release_focus()
		submit_score()

func submit_score():
	print("submitting score")
	save_file(player_name + "," + str(global.time) + "," + str(global.score))

func load_scores():
	pass

func save_file(content):
	var file = FileAccess.open("res://save_game.dat", FileAccess.WRITE)
	file.store_string(load_file())
	file.store_string(content)

func load_file():
	var file = FileAccess.open("res://save_game.dat", FileAccess.READ)
	var content = file.get_as_text()
	return content


