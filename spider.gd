extends Area2D

@export var start: Node2D = null
var max_height = 0
var min_height = 0
var direction = -1
var speed = 45

func _ready():
	max_height = position.y
	min_height = start.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > max_height and direction == 1:
		direction = -1
	if position.y < min_height and direction == -1:
		direction = 1
	
	position.y = position.y + speed * direction * delta
