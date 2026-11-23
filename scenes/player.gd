extends CharacterBody3D

const MOVEMENT_SPEED = 5
const JUMP_SPEED = 8
const GRAVITY = 10

@onready var camera = $Camera3D
@onready var anim_player: AnimationPlayer = $"model/AnimationPlayer"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hide the cursor

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.5 # rotation around the vertical axis (y-axis, in green)
		camera.rotation_degrees.x -= event.relative.y * 0.2 # rotation around a horizontal axis (x-axis, in red)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90.0, 90.0) # limit the angle
	elif event.is_action_pressed("ui_cancel"): # built-in action associated with the ESC key
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # show the cursor

func _physics_process(delta: float) -> void:
	var input_direction_2D = Input.get_vector("left", "right", "forward", "backward") # here, left/right controls the X, and forward/back controls -Y
	var input_direction_3D = Vector3(input_direction_2D.x, 0, input_direction_2D.y) # (X,Y) in 2D translates to (X,0,Y) in 3D
	var direction = transform.basis * input_direction_3D # direction based on the model's current basis
	velocity.x = direction.x * MOVEMENT_SPEED
	velocity.z = direction.z * MOVEMENT_SPEED

	# Add gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
		
	if velocity.length() > 0:
		anim_player.play("walk")
	else:
		anim_player.play("idle")
		
	move_and_slide()
