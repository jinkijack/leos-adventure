extends KinematicBody2D

export (int) var speed = 50
export (bool) var is_one_up = false
var velocity := Vector2.ZERO
var x_direction = 1
var active := false


func _ready():
	$AnimationPlayer.play("Rise")

var alive = true


func _physics_process(delta):
	if active:
		velocity.x = speed * x_direction
		velocity.y += Global.gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_wall():
			x_direction = -x_direction


func _on_Area_body_entered(body):
	if active:
		if is_one_up:
			Global.lives += 1
		else:
			body.power_up()
		queue_free()


func _on_AnimationPlayer_animation_finished(_anim_name):
	active = true
