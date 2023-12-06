extends Area2D

export var auto_teleport := false
export var jump_on_exit := false
export var lock_camera_on_exit := false
onready var drop_position = $Output.global_position
onready var camera_position = $Camera_Out.global_position
var player
var player_on_pipe


func teleport():
	Global.camera_locked = lock_camera_on_exit
	get_tree().call_group("camera", "jump_to", camera_position)
	
	player.global_position = drop_position
	player.velocity = Vector2.ZERO
	
	if jump_on_exit:
		player.bounce()


func _process(_delta):
	if Input.is_action_pressed("Down"):
		if player_on_pipe:
			teleport()


func _on_body_entered(body):
	player = body
	if auto_teleport:
		teleport()
	else:
		player_on_pipe = true


func _on_body_exited(_body):
	player_on_pipe = false
