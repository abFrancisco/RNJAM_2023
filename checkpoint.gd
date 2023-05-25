extends Area2D

var used = false

func toggle():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "frame", 4, 0.5)
	used = true
