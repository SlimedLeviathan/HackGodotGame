extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Reference to AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Set gravity manually if get_gravity() isn't available

var facing_right = true  # Track direction
var paused = false  # Used for pausing movement

var health = 5 # Player hearts
func take_damage():
	health -= 1
	die()
	print("Player has", health, "hearts left")
	
	if health >= 0:
		die()
	else:
		beconme_invincible()
		
func die():
	if take_damage():
		Startpos
		print("Player has respawned.")
	else:
		print("Player has died")

var walk_frame_timer = 0.0  # Timer to alternate walk animations
const WALK_ANIM_SWITCH_TIME = 0.2  # Time interval to switch walk animations

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
		walk_frame_timer += delta  # Update the timer while moving

		# Alternate walk animation based on the timer
		if direction > 0:  # Moving right
			if walk_frame_timer >= WALK_ANIM_SWITCH_TIME:
				walk_frame_timer = 0.0  # Reset the timer
				if anim.animation == "walk_right":
					anim.play("walk_right_2")
				else:
					anim.play("walk_right")
			facing_right = true
		else:  # Moving left
			if walk_frame_timer >= WALK_ANIM_SWITCH_TIME:
				walk_frame_timer = 0.0  # Reset the timer
				if anim.animation == "walk_left":
					anim.play("walk_left_2")
				else:
					anim.play("walk_left")
			facing_right = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Ensure the idle animation only plays if it's not already set
		var idle_animation = "idle_right" if facing_right else "idle_left"
		if anim.animation != idle_animation:
			anim.play(idle_animation)

	move_and_slide()

func setPaused(pause: bool) -> void:
	paused = pause
	
