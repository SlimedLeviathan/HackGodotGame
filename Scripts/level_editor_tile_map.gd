extends TileMapLayer

var selectedBlock = null
var leftPressed = false
var rightPressed = false

var extraPos = [0,0]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var position = event.position - Vector2(viewport.get_window().size.x / 2,viewport.get_window().size.y / 2)
	
	position += Vector2(extraPos[0], extraPos[1])
	
	var coords = local_to_map(to_local(position))
	
	if is_instance_of(event, InputEventMouseButton):
		if event.is_pressed():
			if event.button_index == 1:
				
				setCell(coords)
				
				leftPressed = true
			elif event.button_index == 2:
				rightPressed = true
		else:
			leftPressed = false
			rightPressed = false
		
	elif leftPressed:
		setCell(coords)
	
	elif rightPressed:
		extraPos[0] -= event.relative[0]
		extraPos[1] -= event.relative[1]
		
		self.get_parent().get_node("Camera2D").position.x = extraPos[0]
		self.get_parent().get_node("Camera2D").position.y = extraPos[1]
		

func setCell(coords):
	if (selectedBlock == null):
		self.set_cell(coords)
	else:
		self.set_cell(coords, selectedBlock[2], Vector2i(selectedBlock[0], selectedBlock[1]))
	
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
		saveFile.store_string(getLevelData())
		
		# almost forgot about good code practicing for a second there
		saveFile.flush()
		
		saveFile.close()
	else:
		print("Save file: " + levelName + " could not be opened/created")

func setLevel(level:String) -> void:
	# set the tile map to the data from the parameter
	
	var levelArray = JSON.parse_string(level)
	
	self.clear()
	
	for tile in levelArray:
		self.set_cell(Vector2i(tile[0], tile[1]),tile[4],Vector2i(tile[2], tile[3]))
	
func loadLevel(name:String) -> void:
	var loadFile = FileAccess.open("res://Levels/User Levels/"+name+".txt",FileAccess.READ)
	
	setLevel(loadFile.get_as_text())

func setSelectedBlock(x,y,source):
	selectedBlock = [x,y,source]


func _on_erase_button_pressed() -> void:
	selectedBlock = null
