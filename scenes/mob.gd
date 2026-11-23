class_name Mob extends RigidBody3D

signal mob_killed
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer

var is_dead = false
var speed = randf_range(1,2)

func hurt():
	if not is_dead:
		is_dead = true
		animation_player.play("die")
		mob_killed.emit()
		await get_tree().create_timer(1).timeout
		queue_free()
