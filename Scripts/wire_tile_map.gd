extends TileMapLayer

func setCell(coords, wireNum):
	if (wireNum == null):
		self.set_cell(coords)
	else:
		self.set_cell(coords, 2, Vector2i(wireNum, 0))
		
func setWires(level:String) -> void:
	# set the tile map to the data from the parameter
	var levelArray = JSON.parse_string(level)
	
	self.clear()
	
	for tile in levelArray:
		self.set_cell(Vector2i(tile[0], tile[1]),2,Vector2i(tile[2], 0))

func getWireData() -> String:
	var cells = self.get_used_cells()
	
	var levelArray = []
		
	for cell in cells:
		var coord = Vector2i(cell.x,cell.y)
		
		var tileAtlasCoords = self.get_cell_atlas_coords(coord)
		
		levelArray.append([cell.x, cell.y, tileAtlasCoords.x])
	
	return str(levelArray)
