extends Node

var use_hats: bool = true
var player_color: Color = Color.WHITE
var hat: String = ""
var score: int = 0
var time: int = 0

func randomize_player_color():
	player_color = Color.from_hsv(randf(), 0.8, 0.8, 1.0)
	return player_color

func randomize_hat():
	hat = "res://Textures/hat"+str(randi_range(1,4))+".png"
	return hat
