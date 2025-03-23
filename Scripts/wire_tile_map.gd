extends TileMapLayer

var nextPowered = []

# this is what powers the wires once something powers them
func _process(delta: float) -> void:
	for next in nextPowered:
		power(next[0], next[1], next[2])
	
func power(coords, direction, on):	
	# find the type of wire in the tilemap (if available)
	var atlasCoords = get_cell_atlas_coords(coords)
	
	if atlasCoords.x == -1:
		return
	
	# since, it would have activated the others already
	if ((atlasCoords[1] == 1) == on):
		return
	
	if (getConnected(atlasCoords[0], direction)):
		var newAtlasCoords = Vector2i(atlasCoords[0], 0)
		
		if on:
			newAtlasCoords.y = 1
		
		set_cell(coords, 2,newAtlasCoords)
		
		for connection in wireDict[atlasCoords[0]]:
			if not (connection[0] == direction[0] and connection[1] == direction[1]):
				nextPowered.append([[coords[0] + connection[0], coords[1] + connection[1]], direction, on])

var wireDict = {
	0:[[-1,0],[1,0]],
	1:[[0,1],[0,-1]],
	2:[[-1,0],[1,0],[0,1]],
	3:[[0,1],[0,-1],[1,0]],
	4:[[-1,0],[1,0],[0,-1]],
	5:[[0,1],[0,-1],[-1,0]],
	6:[[-1,0],[0,-1]],
	7:[[-1,0],[0,1]],
	8:[[1,0], [0,1]],
	9:[[0,-1],[1,0]],
	10:[[1,0],[-1,0],[0,1],[0,-1]]
}
func getConnected(atlasX, direction) -> bool:
	var wire = wireDict[atlasX]
	
	var connect = false
	
	for connection in wire:
		if (connection[0] == direction[0] and connection[1] == direction[1]):
			connect = true
			break
	
	return connect

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
