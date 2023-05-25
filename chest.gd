extends Area2D

@export var score: int = 1
var opened = false

func open():
	if not opened:
		opened = true
		$Sprite2D.frame = 1
		return score
	return 0
