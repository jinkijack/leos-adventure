extends Camera2D

export var follow_distance := 600
var Protagonist


func _physics_process(_delta):
	if is_instance_valid(Protagonist) and Protagonist.global_position.x > \
		(global_position.x + follow_distance) and !Global.camera_locked:
		global_position.x = Protagonist.global_position.x - follow_distance
		Global.game_active = true


func jump_to(position: Vector2):
	global_position.x = position.x
