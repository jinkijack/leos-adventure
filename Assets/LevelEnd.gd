extends Node2D

signal level_ended


func end_level(score: int):
	$AnimationPlayer.play("Flag_Down")
	Global.score += score
	Global.level_ending = true


func _on_CameraFreeze_body_entered(_body):
	Global.camera_locked = true


func _on_FlagpoleBottom_body_entered(_body):
	end_level(200)


func _on_FlagpoleMiddle_body_entered(_body):
	end_level(400)


func _on_FlagpoleUpper_body_entered(_body):
	end_level(800)


func _on_FlagpoleTop_body_entered(_body):
	Global.lives += 1
	end_level(1000)


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("level_ended")
