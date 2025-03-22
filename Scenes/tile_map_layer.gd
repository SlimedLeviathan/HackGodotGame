extends TileMapLayer

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levelFolder = DirAccess.open("res://Levels")
	
	var files = levelFolder.get_files()
	
	loadLevel(files[rng.randi_range(0,files.size() - 1)].split(".")[0])
	#saveLevel("Level5", getLevelData())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setLevel(level:String) -> void:
	# set the tile map to the data from the parameter
	
	var levelArray = JSON.parse_string(level)
	
	self.clear()
	
	for tile in levelArray:
		self.set_cell(Vector2i(tile[0], tile[1]),tile[4],Vector2i(tile[2], tile[3]))
		
func getLevelData() -> String:
	var cells = self.get_used_cells()
	
	var levelArray = []
	
	for cell in cells:
		var coord = Vector2i(cell.x,cell.y)
		
		var tileAtlasCoords = self.get_cell_atlas_coords(coord)
		
		levelArray.append([cell.x, cell.y, tileAtlasCoords.x, tileAtlasCoords.y, self.get_cell_source_id(coord)])
	
	return str(levelArray)
	
func saveLevel(levelName:String, levelData:String) ->void:
	var saveFile = FileAccess.open("res://Levels/" + levelName + ".txt", FileAccess.WRITE)
	
	saveFile.store_string(levelData)
	
func loadLevel(name:String) -> void:
	var loadFile = FileAccess.open("res://Levels/"+name+".txt",FileAccess.READ)
	
	setLevel(loadFile.get_as_text())
