class_name Enemy
extends KinematicBody2D

export (int) var walk_speed = 50
export (bool) var is_shelly = false
export (int) var shell_speed = 200
onready var visibility = $VisibilityNotifier2D

var velocity := Vector2.ZERO
var x_direction = -1
var alive = true
onready var animated_sprite = $AnimatedSprite


func _physics_process(delta):
	if visibility.is_on_screen() or walk_speed == shell_speed:
		velocity.x = walk_speed * x_direction
		velocity.y += Global.gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_wall():
			x_direction = -x_direction


func fall():
	queue_free()


func die():
	alive = false
	Global.score_enemy()
	queue_free()


func retreat():
	alive = false
	Global.score_enemy()
	animated_sprite.hide()
	$AnimatedSprite.scale.y = -1
	if walk_speed == 0:
		walk_speed = shell_speed
		x_direction = 1
		arm()
	else:
		walk_speed = 0
		$Left_Killbrush.set_collision_layer_bit(16, false)
		$Right_Killbrush.set_collision_layer_bit(16, false)
		x_direction = 1


func arm():
	yield(get_tree().create_timer(0.1), "timeout")
	$Left_Killbrush.set_collision_layer_bit(15, true)
	$Right_Killbrush.set_collision_layer_bit(15, true)
	alive = true


func _on_I_Died_body_entered(body):
	if body is Player:
		animated_sprite.play("dead")
		if body.alive:
			body.bounce()
		if is_shelly:
			retreat()
		else:
			die()


func _on_Left_Bumper_body_entered(body):
	if walk_speed == 0 and body is Player:
		walk_speed = shell_speed
		x_direction = 1
		arm()


func _on_Right_Bumper_body_entered(body):
	if walk_speed == 0 and body is Player:
		walk_speed = shell_speed
		x_direction = -1
		arm()


func _on_I_Was_Killed_By_Something_Bad_body_entered(_body):
	die()
