extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var jump_timer = $Timer
@onready var raycast = $RayCast2D  # Detects walls
@onready var hitbox = $Hitbox  # Detects player collisions

const GRAVITY = 980.0
const JUMP_FORCE = -250.0  # Jump height
const SPEED = 100.0  # Movement speed
var direction = 1  # -1 (left), 1 (right)
var is_jumping = false  # Ensures slime only jumps when the timer allows

func _ready():
	jump_timer.start()  # Start the first jump cycle

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		is_jumping = true
	else:
		velocity.x = direction * SPEED
		is_jumping = false
	
	if is_jumping:
		velocity.x = 0

	# Check for walls
	if raycast.is_colliding():
		direction *= -1
		flip_sprite(direction)

	# Change animation based on movement state
	if is_on_floor():
		anim.play("grounded")
	else:
		anim.play("flying")

	# Apply movement
	move_and_slide()

func _on_Timer_timeout():
	# Jump logic
	if is_on_floor() and not is_jumping:
		velocity.y = JUMP_FORCE  # Apply jump force
		is_jumping = true
	else:
		velocity.y = 0
		is_jumping = false
		
		velocity.x = direction * SPEED
	
	if is_jumping:
		velocity.x = 0

		# Randomize direction
		var rng = RandomNumberGenerator.new()
		var new_direction = rng.randi_range(-1, 1)

		if new_direction == 0:
			new_direction = 1 if rng.randi_range(0, 1) == 0 else -1  

		# Reverse direction if colliding with a wall
		if raycast.is_colliding():
			new_direction *= -1

		direction = new_direction
		flip_sprite(direction)
 
		jump_timer.start()  # Restart jump timer

func flip_sprite(dir):
	scale.x = abs(scale.x) * dir  # Flip horizontally

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Character":
		body.take_damage()  # Call the player's damage function
