extends Control

@export var world: CharacterBody2D = null
var score: int = 0
var time: int = 0

func toggle():
	$MarginContainer/VBoxContainer/Play.grab_focus()
	$MarginContainer/VBoxContainer/Collected.text = "collected   <>      "+str(score)
	$MarginContainer/VBoxContainer/Time.text = "final time  <>      "+str(time)
	var tween = get_tree().create_tween()
	if modulate.a == 1:
		tween.tween_property(self, "modulate", Color(Color.WHITE, 0.0), 0.3)
		world.set_physics_process(true)
	else:
		tween.tween_property(self, "modulate", Color(Color.WHITE, 1.0), 0.3)
		world.set_physics_process(false)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
