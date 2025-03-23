extends TileMapLayer

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
	
	#the first 2 lines should be the start and endPos
	var data = level.split("\n")
	
	var startPos = JSON.parse_string(data[0])
	var endPos = JSON.parse_string(data[1])
	
	var levelArray = JSON.parse_string(data[2])
	
	self.clear()
	
	for tile in levelArray:
		self.set_cell(Vector2i(tile[0], tile[1]),tile[4],Vector2i(tile[2], tile[3]))
		
	get_parent().get_node("WireTileMapLayer").setWires(data[3])
	
	get_parent().get_node("Character").position = Vector2(0,0)
	
	var globalOffset = to_global(map_to_local(Vector2i(startPos[0], startPos[1])))
	
	position = globalOffset
	get_parent().get_node("WireTileMapLayer").position = globalOffset
	
func loadLevel(name:String) -> void:
	var loadFile = FileAccess.open("res://Levels/Game/"+name+".txt",FileAccess.READ)
	
	setLevel(loadFile.get_as_text())
