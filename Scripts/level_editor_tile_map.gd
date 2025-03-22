extends TileMapLayer

var selectedBlock = null
var leftPressed = false
var rightPressed = false

var extraPos = [0,0]

var defaultStart = [0,0]
var defaultEnd = [10,0]

var prevStartPos = [0,0]
var prevEndPos = [1,0]
var startPos = [defaultStart[0], defaultStart[1]]
var endPos = [defaultEnd[0], defaultEnd[1]]

var previousBlock = null

var movingStart = false
var movingEnd = false

func _ready() -> void:
	resetLevel()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var position = event.position - Vector2(viewport.get_window().size.x / 2,viewport.get_window().size.y / 2)
	
	position += Vector2(extraPos[0], extraPos[1])
	
	var coords = local_to_map(to_local(position))
	
	if is_instance_of(event, InputEventMouseButton):
		if event.is_pressed():
			if event.button_index == 1:
				if (coords.x == startPos[0] and coords.y == startPos[1]):
					movingStart = true
					prevStartPos = [coords.x, coords.y]
					previousBlock = null
				elif (coords.x == endPos[0] and coords.y == endPos[1]):
					movingEnd = true
					prevEndPos = [coords.x, coords.y]
					previousBlock = null
				else:
					setCell(coords)
					
					leftPressed = true
			elif event.button_index == 2:
				rightPressed = true
		else:
			leftPressed = false
			rightPressed = false
			
			if (movingStart):
				if startPos[0] == endPos[0] and startPos[1] == endPos[1]:
					startPos = [prevStartPos[0], prevStartPos[1]]
					
			
			if (movingEnd):
				if startPos[0] == endPos[0] and startPos[1] == endPos[1]:
					endPos = [prevEndPos[0], prevEndPos[1]]
					
			movingStart = false
			movingEnd = false
	
	elif movingStart or movingEnd:
		var prevPos = Vector2()
		var block = []
		var newBlock = null
		
		var atlasCoords = get_cell_atlas_coords(coords)
		var id = get_cell_source_id(coords)
		if (id != 0 and id != 3):
			newBlock = [atlasCoords.x, atlasCoords.y, id]
		else:
			newBlock = [null]
		
		if movingStart:
			prevPos.x = startPos[0]
			prevPos.y = startPos[1]
			startPos = [coords.x, coords.y]
			block = [0,0,0]
		elif movingEnd:
			prevPos.x = endPos[0]
			prevPos.y = endPos[1]
			endPos = [coords.x, coords.y]
			block = [0,0,3]
		
		setCellToBlock(prevPos, previousBlock)
		setCellToBlock(coords, block)
		
		if (newBlock[0] != null):
			previousBlock = newBlock
		
	elif leftPressed:
		if not((coords.x == startPos[0] and coords.y == startPos[1]) or (coords.x == endPos[0] and coords.y == endPos[1])):
			setCell(coords)
	
	elif rightPressed:
		extraPos[0] -= event.relative[0]
		extraPos[1] -= event.relative[1]
		
		self.get_parent().get_node("Camera2D").position.x = extraPos[0]
		self.get_parent().get_node("Camera2D").position.y = extraPos[1]
		

func setCell(coords):	
	if (selectedBlock == null):
		self.set_cell(coords)
		get_parent().get_node("WireTileMapLayer").setCell(coords, null) # so it also deletes the wires
	elif typeof(selectedBlock[2]) == TYPE_STRING:
		get_parent().get_node("WireTileMapLayer").setCell(coords, selectedBlock[0])
	else:
		self.set_cell(coords, selectedBlock[2], Vector2i(selectedBlock[0], selectedBlock[1]))
	
	get_parent().get_node("Camera2D/Control").processChange()
	
func setCellToBlock(coords, block):
	if (block == null):
		self.set_cell(coords)
	else:
		self.set_cell(coords, block[2], Vector2i(block[0], block[1]))
	
	get_parent().get_node("Camera2D/Control").processChange()
	

func getLevelData() -> String:
	var cells = self.get_used_cells()
	
	var levelArray = []
	
	for cell in cells:
		var coord = Vector2i(cell.x,cell.y)
		
		var tileAtlasCoords = self.get_cell_atlas_coords(coord)
		
		levelArray.append([cell.x, cell.y, tileAtlasCoords.x, tileAtlasCoords.y, self.get_cell_source_id(coord)])
	
	return str(levelArray)
	
func saveLevel(levelName:String) ->void:
	var saveFile = FileAccess.open("res://Levels/User Levels/" + levelName + ".txt", FileAccess.WRITE)
	
	if (saveFile != null):
		saveFile.store_string(str(startPos) + "\n")
		saveFile.store_string(str(endPos) + "\n")
		saveFile.store_string(getLevelData() + "\n")
		saveFile.store_string(get_parent().get_node("WireTileMapLayer").getWireData())
		
		# almost forgot about good code practicing for a second there
		saveFile.flush()
		
		saveFile.close()
	else:
		print("Save file: " + levelName + " could not be opened/created")

func setLevel(level:String) -> void:
	# set the tile map to the data from the parameter
	
	#the first 2 lines should be the start and endPos
	var data = level.split("\n")
	
	startPos = JSON.parse_string(data[0])
	endPos = JSON.parse_string(data[1])
	
	var levelArray = JSON.parse_string(data[2])
	
	self.clear()
	
	for tile in levelArray:
		self.set_cell(Vector2i(tile[0], tile[1]),tile[4],Vector2i(tile[2], tile[3]))
		
	get_parent().get_node("WireTileMapLayer").setWires(data[3])
	
func loadLevel(name:String) -> void:
	var loadFile = FileAccess.open("res://Levels/User Levels/"+name+".txt",FileAccess.READ)
	
	setLevel(loadFile.get_as_text())

func resetLevel():
	self.clear()
	startPos = [defaultStart[0], defaultStart[1]]
	endPos = [defaultEnd[0], defaultEnd[1]]
	
	setCellToBlock(Vector2(startPos[0],startPos[1]), [0,0,0])
	setCellToBlock(Vector2(endPos[0],endPos[1]), [0,0,3])

func setSelectedBlock(x,y,source):
	selectedBlock = [x,y,source]

func _on_erase_button_pressed() -> void:
	selectedBlock = null
