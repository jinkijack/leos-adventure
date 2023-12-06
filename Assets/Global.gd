extends Node

export var gravity = 500
export var score := 0
export var level_score := 0
export var lives := 3
export var time := 1500
export var enemy_chain := 1
export var game_active := false
export var level_ending := false
export var camera_locked := false


func add_score(points: int):
	level_score += points


func score_level():
	score += level_score + int(time/10.0)
	level_score = 0


func score_enemy():
	add_score(100 * enemy_chain)
	enemy_chain += 1


func protagonist_on_ground():
	enemy_chain = 1
