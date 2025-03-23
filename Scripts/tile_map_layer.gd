extends TileMapLayer

<<<<<<< HEAD
# Declare the variable for the character scene.
var character_scene : PackedScene
var slime_scene = preload("res://Scenes/Slime.tscn")

# Store existing slimes for cleanup
var current_slimes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.

func setLevel(level: String) -> void:
	# Ensure level data is not empty
	if level.is_empty():
		push_error("Level data is empty!")
		return
=======
func powerTile(coords, on, direction = null):
	var atlasCoords = get_cell_atlas_coords(coords)
	var id = get_cell_source_id(coords)
	
	# door
	if id == 7:
		if on:
			set_cell(coords, id, Vector2i(0,1))
		else:
			set_cell(coords, id, Vector2i(0,0))
	# wavy walls
	elif id == 6:
		var wallID = atlasCoords.y % 2
		
		if on:
			set_cell(coords, id, Vector2i(0,wallID))
		else:
			set_cell(coords, id, Vector2i(0,wallID + 2))
			
		# check above and below to see if they are wavy walls as well
		var aboveCoords = Vector2i(coords.x, coords.y - 1)
		var belowCoords = Vector2i(coords.x, coords.y + 1)
		
		if direction == null:
			powerTile(aboveCoords, on, -1)
			powerTile(belowCoords, on, 1)
		elif direction == -1:
			powerTile(aboveCoords, on, -1)
		elif direction == 1:
			powerTile(belowCoords, on, 1)
	# lever (usually by the player)
	elif id == 9:
		if on:
			set_cell(coords, id, Vector2i(0,1))
		else:
			set_cell(coords, id, Vector2i(0,0))

		var wireTM = get_parent().get_node("WireTileMapLayer")
		
		wireTM.power(Vector2i(coords.x,coords.y + 1), [0,1],on)
		wireTM.power(Vector2i(coords.x + 1,coords.y), [1,0],on)
		wireTM.power(Vector2i(coords.x,coords.y - 1), [0,-1],on)
		wireTM.power(Vector2i(coords.x - 1,coords.y), [-1,0],on)
		
func setLevel(level:String) -> void:
	# set the tile map to the data from the parameter
>>>>>>> daa12eb4d9f5cfa2f639f4e9beb5f87283f94c78
	
	var data = level.split("\n")
	
<<<<<<< HEAD
	if data.size() < 3:
		push_error("Invalid level data format!")
		return
	
	# Parse JSON data safely
	var startPos = JSON.parse_string(data[0]) if data[0] else null
	var endPos = JSON.parse_string(data[1]) if data[1] else null
	var levelArray = JSON.parse_string(data[2]) if data[2] else null

	if startPos == null or endPos == null or levelArray == null:
		push_error("Failed to parse level JSON data!")
		return
=======
	var startPos = JSON.parse_string(data[0])
	var endPos = JSON.parse_string(data[1])
	
	var levelArray = JSON.parse_string(data[2])
>>>>>>> daa12eb4d9f5cfa2f639f4e9beb5f87283f94c78
	
	self.clear()
	
	# Place tiles
	for tile in levelArray:
		if tile.size() < 5:
			continue  # Skip invalid tile entries
		self.set_cell(Vector2i(tile[0], tile[1]), tile[4], Vector2i(tile[2], tile[3]))
	
	# Ensure data[3] exists before using it
	if data.size() > 3:
		var wire_layer = get_parent().get_node_or_null("WireTileMapLayer")
		if wire_layer:
			wire_layer.setWires(data[3])
	
	# Clear old slimes before spawning new ones
	clear_slimes()
	
	# Get player reference and reset position
	var player = get_parent().get_node_or_null("Character")
	if player:
		var player_position = player.position
		spawn_slimes(levelArray, player_position)
		player.position = Vector2(0, 0)
	
	# Set level position
	var globalOffset = to_global(map_to_local(Vector2i(startPos[0], startPos[1])))
	position = globalOffset
	
	var wire_layer = get_parent().get_node_or_null("WireTileMapLayer")
	if wire_layer:
		wire_layer.position = globalOffset

func spawn_slimes(levelArray: Array, player_position: Vector2) -> void:
	var rng = RandomNumberGenerator.new()
	var num_slimes = 1 #rng.randi_range(1, 5)  # Random number of slimes (1-5)
	var spawn_positions = []

	# Collect valid ground tiles as spawn positions
	for tile in levelArray:
		if tile.size() < 2:
			continue  # Skip invalid tile entries
		var tile_pos = Vector2i(tile[0], tile[1])
		var world_pos = to_global(map_to_local(tile_pos))  # Convert tile position to world position
		
		# Ensure it's a ground tile and not too close to the player
		if is_ground_tile(tile_pos) and world_pos.distance_to(player_position) > 100:
			spawn_positions.append(world_pos)

	# Ensure we don't spawn more slimes than available positions
	num_slimes = min(num_slimes, spawn_positions.size())

	# Track used spawn indices to avoid duplicates
	var used_indices = []
	for i in range(num_slimes):
		var spawn_index
		while true:
			spawn_index = rng.randi_range(0, spawn_positions.size() - 1)
			if spawn_index not in used_indices:
				used_indices.append(spawn_index)
				break
		
		var spawn_pos = spawn_positions[spawn_index]
		var slime = slime_scene.instantiate()
		slime.position = spawn_pos
		add_child(slime)  # Ensure slime is added to the correct parent
		
		# Store reference for cleanup
		current_slimes.append(slime)

func clear_slimes():
	# Remove all existing slimes safely
	for slime in current_slimes:
		if is_instance_valid(slime):
			slime.queue_free()
	current_slimes.clear()

func is_ground_tile(tile_pos: Vector2i) -> bool:
	# Modify this based on how ground tiles are represented in your tilemap
	var tile_data = get_cell_atlas_coords(tile_pos)
	return tile_data != null and tile_data.x != -1  # Ensure it's a valid tile

func loadLevel(name: String) -> void:
	var loadFile = FileAccess.open("res://Levels/Game/" + name + ".txt", FileAccess.READ)
	
	if not loadFile:
		push_error("Level file not found: " + name)
		return
	
	setLevel(loadFile.get_as_text())
