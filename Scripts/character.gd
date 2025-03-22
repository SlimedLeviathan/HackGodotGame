extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Reference to AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Set gravity manually if get_gravity() isn't available

var facing_right = true  # Track direction
var paused = false  # Used for pausing movement

func _physics_process(delta: float) -> void:
	if paused:
		return  # Stop movement if the game is paused

	# Add gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Apply gravity

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")  # If you have a jump animation

	# Get input direction for left and right movement
	var direction := 0
	if Input.is_action_pressed("move_left"):
		direction -= 1  # Move left
	if Input.is_action_pressed("move_right"):
		direction += 1  # Move right

	# Apply movement
	if direction != 0:
		velocity.x = direction * SPEED

		# Set animation based on direction
		if direction > 0:
			anim.play("walk_right")
			facing_right = true
		else:
			anim.play("walk_left")
			facing_right = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Set idle animation based on last facing direction
		anim.play("idle_right" if facing_right else "idle_left")

	move_and_slide()

func setPaused(pause: bool) -> void:
	paused = pause
