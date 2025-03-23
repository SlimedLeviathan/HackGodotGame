extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Reference to AnimatedSprite2D

const SPEED = 25.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Set gravity manually if get_gravity() isn't available

var facing_right = true  # Track direction
var paused = false  # Used for pausing movement

var health = 5 # Player hearts
func take_damage():
	health -= 1
	
	var heartUIContainer:HBoxContainer = get_node("UIControl/HeartContainer/HBoxContainer")
	
	heartUIContainer.remove_child(heartUIContainer.get_child(0))
		
	
	die()
	print("Player has", health, "hearts left")
<<<<<<< HEAD

=======
	# set invincibility
		
>>>>>>> daa12eb4d9f5cfa2f639f4e9beb5f87283f94c78
func die():
	if health > 0:
		position = Vector2(0,0)
		print("Player has respawned.")
	else:
		# Reload the game when they are dead.
		print("Player has died")
var wallHolding = 0

var lastEntered = {}

var walk_frame_timer = 0.0  # Timer to alternate walk animations
const WALK_ANIM_SWITCH_TIME = 0.2  # Time interval to switch walk animations

func _physics_process(delta: float) -> void:
	if paused:
		return  # Stop movement if the game is paused

	# Add gravity
	if not is_on_floor():
		var gravity = GRAVITY * delta
		
		if wallHolding != 0:
			velocity.y = 50 
		else:
			# Apply gravity
			velocity.y += gravity
	
	# Get input direction for left and right movement
	var direction := 0
	if Input.is_action_pressed("move_left"):
		direction -= 1  # Move left
	if Input.is_action_pressed("move_right"):
		direction += 1  # Move right
			
	# Handle jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")  # If you have a jump animation

		elif wallHolding != 0:
			velocity.y = JUMP_VELOCITY / 1.5
			velocity.x += JUMP_VELOCITY * wallHolding / 1.5
			wallHolding = 0
			anim.play("jump")
			
	# Apply movement
	if direction != 0:
		velocity.x += direction * SPEED
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
		velocity.x = velocity.x / 5
		# Ensure the idle animation only plays if it's not already set
		var idle_animation = "idle_right" if facing_right else "idle_left"
		if anim.animation != idle_animation:
			anim.play(idle_animation)
		
	if abs(velocity.x) > 300:
		velocity.x = velocity.x / 1.1

	move_and_slide()

func setPaused(pause: bool) -> void:
	paused = pause
	
func tileInteract(block, direction):
	# coin
	if block[2] == 8:
		# add one to coins
		get_node("/root/Main").addCoin()
		return "Remove"
	
	# end door
	if (block[2] == 3):
		get_node("/root/Main").newLevel()
		
	# spike
	if block[2] == 5:
		self.take_damage()
		
	# wavy walls
	if block[2] == 6:
		if block[1] == 1 and direction == "Left":
			wallHolding = -1
			
		elif block[1] == 0 and direction == "Right":
			wallHolding = 1
			
func tileUninteract(coords, block, direction):	
	# wavy walls	
	if block[2] == 6: 
	#and (lastEntered[direction][0] != coords[0] or lastEntered[direction][1] != coords[1]):
		if block[1] == 1 and direction == "Left":
			wallHolding = 0
			
		elif block[1] == 0 and direction == "Right":
			wallHolding = 0

func bodyEntered(body, area, direction):	
	if (body != self):	
		if is_instance_of(body, TileMapLayer):
			var tml = body as TileMapLayer
			
			var globPos = area.to_global(area.position)
		
			var tileCoords = tml.local_to_map(tml.to_local(globPos))
			
			lastEntered[direction] = tileCoords
			
			var atlasCoords = tml.get_cell_atlas_coords(tileCoords)
			
			var block = [atlasCoords.x, atlasCoords.y, tml.get_cell_source_id(tileCoords)]
			
			if (tileInteract(block, direction) == "Remove"):
				tml.set_cell(tileCoords)

func bodyExited(body:Node2D, area:CollisionShape2D, direction):
	if (body != self):
		if is_instance_of(body,TileMapLayer):
			var tml = body as TileMapLayer
			
			var globPos = area.to_global(area.position)
		
			var tileCoords = tml.local_to_map(tml.to_local(globPos))
			
			var atlasCoords = tml.get_cell_atlas_coords(tileCoords)
			
			var block = [atlasCoords.x, atlasCoords.y, tml.get_cell_source_id(tileCoords)]
			
			tileUninteract(tileCoords, block, direction)

func _on_bottom_area_body_entered(body: Node2D) -> void:
	bodyEntered(body, get_node("BottomArea/CollisionShape2D"), "Down")


func _on_right_area_body_entered(body: Node2D) -> void:
	bodyEntered(body, get_node("RightArea/CollisionShape2D"), "Right")


func _on_left_area_body_entered(body: Node2D) -> void:
	bodyEntered(body, get_node("LeftArea/CollisionShape2D"), "Left")


func _on_top_area_body_entered(body: Node2D) -> void:
	bodyEntered(body, get_node("TopArea/CollisionShape2D"), "Up")


func _on_bottom_area_body_exited(body: Node2D) -> void:
	bodyExited(body, get_node("BottomArea/CollisionShape2D"), "Down")


func _on_top_area_body_exited(body: Node2D) -> void:
	bodyExited(body, get_node("TopArea/CollisionShape2D"), "Up")


func _on_right_area_body_exited(body: Node2D) -> void:
	bodyExited(body, get_node("RightArea/CollisionShape2D"), "Right")


func _on_left_area_body_exited(body: Node2D) -> void:
	bodyExited(body, get_node("LeftArea/CollisionShape2D"), "Left")


func _on_middle_area_body_entered(body: Node2D) -> void:
	
	# im using this for the switches that way we dont have problems with the separate hitboxes
	if body != self and is_instance_of(body, TileMapLayer):
		var tml = body as TileMapLayer
		var area:CollisionShape2D = get_node("MiddleArea/CollisionShape2D")
		
		var globPos = area.to_global(area.position)
		
		var tileCoords = tml.local_to_map(tml.to_local(globPos))
		
		var atlasCoords = tml.get_cell_atlas_coords(tileCoords)
		
		var block = [atlasCoords.x, atlasCoords.y, tml.get_cell_source_id(tileCoords)]
		
		if block[2] == 9:
			get_parent().get_node("TileMapLayer").powerTile(tileCoords,block[1] != 1)
			


func _on_bottom_left_area_body_entered(body: Node2D) -> void:
	bodyEntered(body, get_node("BottomLeftArea/CollisionShape2D"), "Left")

func _on_bottom_left_area_body_exited(body: Node2D) -> void:
	bodyExited(body, get_node("BottomLeftArea/CollisionShape2D"), "Left")


func _on_bottom_right_area_body_entered(body: Node2D) -> void:
	bodyEntered(body, get_node("BottomRightArea/CollisionShape2D"), "Right")


func _on_bottom_right_area_body_exited(body: Node2D) -> void:
	bodyExited(body, get_node("BottomRightArea/CollisionShape2D"), "Right")
