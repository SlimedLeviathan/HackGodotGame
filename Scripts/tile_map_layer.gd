extends TileMapLayer

# Declare the variable for the character scene.
var character_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func setLevel(level:String) -> void:
	# set the tile map to the data from the parameter
	
	#the first 2 lines should be the start and endPos
	var data = level.split("\n")
	
	print(data)
	
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
