extends Node2D


func _ready():
	$AnimationPlayer.play("Boing")


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
