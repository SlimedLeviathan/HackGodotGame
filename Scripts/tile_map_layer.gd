extends TileMapLayer

var rng = RandomNumberGenerator.new()

# Declare the variable for the character scene.
var character_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func setLevel(level:String) -> void:
	# set the tile map to the data from the parameter
	
	var levelArray = JSON.parse_string(level)
	
	self.clear()
	
	for tile in levelArray:
		self.set_cell(Vector2i(tile[0], tile[1]),tile[4],Vector2i(tile[2], tile[3]))
	
func loadLevel(name:String) -> void:
	var loadFile = FileAccess.open("res://Levels/"+name+".txt",FileAccess.READ)
	
	setLevel(loadFile.get_as_text())
