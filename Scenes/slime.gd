extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var jump_timer = $Timer

const GRAVITY = 980.0
const JUMP_FORCE = -200.0  # Jump power
const SPEED = -200.0  # Movement speed when jumping
var direction = 1  # 1 = right, -1 = left

func _ready():
	jump_timer.start()  # Start jump timer

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		anim.play("flying")
	else:
		velocity.x / 10
		anim.play("grounded")

	# Move the slime
	velocity.x = direction * SPEED

	# Apply movement
	move_and_slide()

func _on_Timer_timeout():
	# Make the slime jump
	velocity.y = JUMP_FORCE
	anim.play("flying")  # Play jump animation

	# Randomly change direction (if no walls detected)
	if randi() % 2 == 0:
		direction *= -1  # Flip direction

	# Restart timer
	jump_timer.start()

func _on_Hitbox_body_entered(body):
	if body.is_in_group("player"):  # Make sure the player is in the correct group
		body.take_damage(20)  # Call player's damage function
