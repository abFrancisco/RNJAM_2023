extends CharacterBody2D


const MAX_SPEED = 90.0
const LADDER_SPEED = 60.0
const ACCELERATION = 15.0
const JUMP_VELOCITY = -175
const MAX_JUMP_REPEAT = 26
@onready var global = get_node("/root/Global")
var speed = 0.0
var last_direction = 0.0
var on_ladder = false
var on_door: Area2D = null
var last_checkpoint: Area2D = null#set this to the first checkpoint whenn game is finished
var score = 0
var time = 0
var dead = false
@export var collectibles_label: Control = null
@export var time_label: Control = null
@export var pause_menu: Control = null
@export var end_menu: Control = null
@export var restart_menu: Control = null
@export var music: AudioStreamPlayer = null

var jump_counter = 0
var jump_repeat = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if global.use_hats:
		$Hat.texture = load(global.hat)
	$Sprite2D.modulate = global.player_color
	collectibles_label.add_theme_font_size_override("font_size", 8)
	time_label.add_theme_font_size_override("font_size", 8)

func _physics_process(delta):
	if not dead:
		if Input.is_action_pressed("saltar") and (jump_repeat < MAX_JUMP_REPEAT):
			jump_repeat += 1
			velocity.y = JUMP_VELOCITY + jump_repeat * 4
			if jump_repeat == 1:
				$Jump.play()
		if Input.is_action_just_released("saltar"):
			jump_repeat = MAX_JUMP_REPEAT
		
		if not is_on_floor():
			if not Input.is_action_pressed("saltar"):
				jump_repeat += 1
			if not on_ladder:
				velocity.y += gravity * delta
			#$Sprite2D.frame = 5
		if is_on_floor():
			#$Sprite2D.frame = 0
			jump_repeat = 0
		
		if Input.is_action_just_pressed("interagir") and on_door:
			if on_door.link:
				position = on_door.link.position
		
		var direction = snapped(Input.get_axis("esquerda", "direita"), 1.0)
		
		if direction:
			if direction > 0:
				speed = min(speed + ACCELERATION, MAX_SPEED)
			if direction < 0:
				speed = max(speed - ACCELERATION, -MAX_SPEED)
			velocity.x = speed
			last_direction = direction
		else:
			speed = move_toward(speed, 0, ACCELERATION)
			velocity.x = speed
		
		if on_ladder:
			jump_repeat = MAX_JUMP_REPEAT / 4 * 3
			if Input.is_action_pressed("saltar"):
				velocity.y = -LADDER_SPEED
			else:
				velocity.y += gravity * delta
		
		if velocity.x != 0 and velocity.y == 0:
			$Trail_particles.emitting = true
		else:
			$Trail_particles.emitting = false
		
		if velocity.x < 0:
			if velocity.y < 0:
				$AnimationPlayer.play("jump_left")
			elif velocity.y == 0:
				$AnimationPlayer.play("walk_left")
			elif velocity.y > 0:
				$AnimationPlayer.play("fall")
		elif velocity.x > 0:
			if velocity.y < 0:
				$AnimationPlayer.play("jump_right")
			elif velocity.y == 0:
				$AnimationPlayer.play("walk_right")
			elif velocity.y > 0:
				$AnimationPlayer.play("fall")
		elif velocity.y > 0:
			$AnimationPlayer.play("fall")
		else:
			$AnimationPlayer.play("idle")
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, last_direction * sign(velocity.x) * ACCELERATION)
		velocity.y += delta * gravity
		print(velocity)
		if is_on_floor():
			$AnimationPlayer.play("dead")
	move_and_slide()

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.toggle()

func _on_area_2d_body_entered(body):
	print(body.get_groups())
	if body.is_in_group("ladder"):
		on_ladder = true
		print(body.layer)
	elif body.is_in_group("spike"):
		die()

func _on_area_2d_body_exited(_body):
	on_ladder = false

func _on_area_2d_area_entered(area):#enter portal
	if area.is_in_group("portal"):
		on_door = area
	if area.is_in_group("spider"):
		die()
	if area.is_in_group("checkpoint"):
		last_checkpoint = area
		if not area.used:
			$Checkpoint.play()
		area.toggle()
	if area.is_in_group("chest"):
		if not area.opened:
			$Pickup.play()
		update_score(area.open())
	if area.is_in_group("end"):
		game_over()

func _on_area_2d_area_exited(area):#exit portal
	if area.is_in_group("portal"):
		on_door = null

func update_score(value: int):
	score += value
	collectibles_label.text = str(score)

func update_time(value: int):
	time += value
	time_label.text = str(time)

func pause_for(seconds: float):
	var timer = get_tree().create_timer(seconds, true, false, true)
	timer.connect("timeout", pause_timeout)
	get_tree().paused = true

func pause_timeout():
	get_tree().paused = false
	print("timeout")

func slow_down(seconds: float):
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(Engine, "time_scale", 0.1, 0.1)
	tween.tween_property(Engine, "time_scale", 1.0, seconds - 0.1)
	Engine.time_scale

func respawn():
	position = last_checkpoint.position
	dead = false

func die():
	if not dead:
		var timer = get_tree().create_timer(2.0, true, false, true)
		timer.connect("timeout", dead_timeout)
		dead = true
		slow_down(0.5)

func dead_timeout():
	restart_menu.toggle()

func game_over():
	end_menu.score = score
	end_menu.time = time
	end_menu.toggle()

func _on_timer_timeout():
	update_time(1)


func _on_audio_stream_player_finished():
	music.play()

func _on_normal_finished():
	music.play()
