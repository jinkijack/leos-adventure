extends Node2D

export(Resource) var protagonist_scene
export(Array, Resource) var levels: Array

onready var score = $Game_Camera/Score
onready var lives = $Game_Camera/Lives
onready var time = $Game_Camera/Time
onready var player_spawn = $Player_Spawn

var current_level := 0
var level
var player
var camera_start_pos
var player_big_on_reset := false


func _ready():
	camera_start_pos = $Game_Camera.position
	new_player()
	load_level(current_level)


func _process(_delta):
	score.text = "Score: " + str(Global.score + Global.level_score)
	lives.text = "Lives: " + str(Global.lives)
	time.text = "Time:" + str(Global.time)


func _on_Protagonist_i_died():
	yield(get_tree().create_timer(1.0), "timeout")
	Global.lives -= 1
	if Global.lives < 0:
		Global.score = 0
		Global.lives = 3
		current_level = 0
	reset()


func new_player():
	player = protagonist_scene.instance()
	add_child(player)
	player.position = player_spawn.position
	$Game_Camera.Protagonist = player
	player.connect("i_died", self, "_on_Protagonist_i_died")
	if player_big_on_reset:
		player.power_up()
	player_big_on_reset = false


func load_level(number: int):
	level = levels[number].instance()
	add_child(level)
	level.connect("level_end", self, "level_won")


func reset():
	Global.level_ending = false
	Global.camera_locked = false
	Global.level_score = 0
	if is_instance_valid(level):
		level.queue_free()
	call_deferred("_reset_deferred")


func level_won():
	current_level += 1
	if current_level >= levels.size():
		current_level = 0
	player_big_on_reset = true
	Global.score_level()
	reset()


func _reset_deferred():
	$Game_Camera.position = camera_start_pos
	new_player()
	load_level(current_level)
	Global.time = level.level_time
	Global.game_active = false


func _on_Timer_Time_timeout():
	if Global.game_active and !Global.level_ending:
		Global.time -= 1
		if Global.time <= 0:
			if player.alive:
				player.die()


func _on_Sweep_body_entered(body):
	body.fall()
