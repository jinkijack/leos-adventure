class_name Player
extends KinematicBody2D

export (int) var speed = 200
export (int) var run_speed = 250
export (int) var jump_speed = 900

signal i_died

var velocity := Vector2.ZERO
var broke_block := false
var alive := true
var jumping := false
var is_shroomed := false
onready var animated_sprite = $AnimatedSprite
onready var audioJump = $AudioJump


func get_input():
	velocity.x = 0
	var move_speed = speed
	if Input.is_action_pressed("Action"):
		move_speed = run_speed
	if Input.is_action_pressed("Right"):
		velocity.x += move_speed
		animated_sprite.flip_h = false
		animated_sprite.animation = "walk"
	elif Input.is_action_pressed("Left"):
		velocity.x -= move_speed
		animated_sprite.animation = "walk"
		animated_sprite.flip_h = true
	else:
		animated_sprite.animation = "idle"

func break_block():
	velocity.y = -abs(velocity.y)
	broke_block = true


func _physics_process(delta):
	if Global.level_ending:
		velocity.x = speed
	else:
		get_input()
	velocity.y += Global.gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("Jump") or Input.is_action_just_pressed("Up"):
		if is_on_floor() and !jumping and !Global.level_ending:
			jumping = true
			audioJump.play()
			if animated_sprite.animation != "jump":
				animated_sprite.animation = "jump"
			velocity.y = -jump_speed
			broke_block = false
			


func bounce():
	velocity.y = -abs(-jump_speed / 2)


func fall():
	die()


func power_up():
	scale.y = 1.5
	is_shroomed = true


func die():
	if is_shroomed:
		is_shroomed = false
		scale.y = 1
	else:
		alive = false
		queue_free()
		emit_signal("i_died")


func _on_I_Died_body_entered(body):
	if body.alive:
		die()


func _on_My_feet_body_entered(_body):
	Global.protagonist_on_ground()
	jumping = false
