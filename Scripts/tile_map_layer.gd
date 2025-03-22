extends TileMapLayer

var rng = RandomNumberGenerator.new()

# Declare the variable for the character scene.
var character_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Load the character scene
	#character_scene = preload("res://Scenes/Character.tscn")
	
	#var levelFolder = DirAccess.get_files_at("res://Levels")
	#
	#loadLevel(files[rng.randi_range(0,files.size() - 1)].get_basename())
	#saveLevel("Level5", getLevelData())
	
	#Add the character to the scene at a specific position
	#var character = character_scene.instantiate()
	#character.position = Vector2(100, 100) 
	#get_tree().root.add_child(character)
	#self.get_parent().add_child(character)
	
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
	
func loadLevel(name:String) -> void:
	var loadFile = FileAccess.open("res://Levels/"+name+".txt",FileAccess.READ)
	
	setLevel(loadFile.get_as_text())
