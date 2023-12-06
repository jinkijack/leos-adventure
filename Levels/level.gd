extends Node2D

signal level_end
export var level_time := 1500


func _on_LevelEnd_level_ended():
	emit_signal("level_end")
