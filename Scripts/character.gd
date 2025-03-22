extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var paused = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction for left and right movement.
	# The "ui_left" and "ui_right" keys are mapped in the Input Map.
	var direction := 0
	if Input.is_action_pressed("ui_left"):
		direction -= 1  # Move left
	if Input.is_action_pressed("ui_right"):
		direction += 1  # Move right

	# Apply the movement in the X direction
	velocity.x = direction * SPEED

	# Handle deceleration when no keys are pressed
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move the character with collision detection.
	if not paused:
		move_and_slide()

func setPaused(pause):
	paused = pause
