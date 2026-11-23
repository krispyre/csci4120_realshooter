extends Node3D

const MOB_SCENE = preload("res://scenes/mob.tscn")
@onready var mob_container = $MobContainer
@onready var player = $player
@onready var markers = [$spawn1, $spawn2, $spawn3, $spawn4, $spawn1]

var score = 0
@onready var score_label: Label = $HUD/MarginContainer/ScoreLabel
@onready var msg: Label = $HUD/msg

func _on_mob_spawn_timer_timeout() -> void:
	var new_mob = MOB_SCENE.instantiate()
	var random_marker_choice = randi_range(0, 3)
	var random_factor = randf_range(0, 1)
	new_mob.global_position = markers[random_marker_choice].global_position * random_factor + markers[random_marker_choice+1].global_position * (1 - random_factor)
	new_mob.mob_killed.connect(on_mob_killed)
	mob_container.add_child(new_mob)

func _physics_process(delta: float) -> void:
	for mob in mob_container.get_children():
		var direction = mob.global_position.direction_to(player.global_position)
		mob.linear_velocity = direction * mob.speed
		mob.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI

func on_mob_killed() -> void:
	score += 1
	print("Score: " + str(score))
	score_label.text = "Score: " + str(score)
