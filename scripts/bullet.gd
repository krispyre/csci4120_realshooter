extends Area3D

const SPEED = 10
const MAX_RANGE = 10

var travelled = 0

func _physics_process(delta: float) -> void:
	position += -transform.basis.z * SPEED * delta
	travelled += SPEED * delta
	if travelled > MAX_RANGE:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body is Mob:
		body.hurt()
