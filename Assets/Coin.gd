extends KinematicBody2D


func _on_Touched_Player_body_entered(_body):
	call_deferred("collected")


func collected():
	Global.add_score(200)
	$Touched_Player/CollisionShape2D.disabled = true
	visible = false
	$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	queue_free()
