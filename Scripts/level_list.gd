extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setLevels()
	
func setLevels():
	# get rid of all of the other things incase there were some there
	self.clear()
	
	# get all of the levels from the user levels folder
	var levels = DirAccess.get_files_at("res://Levels/User Levels")
	
	for level in levels:
		self.add_item(level.get_basename())


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (mouse_button_index == 1): # making sure its only the left click that selects the save
		get_parent().hideThis()
		
		# set the tilemap to the data
		get_node("/root/LevelEditor/TileMapLayer").loadLevel(self.get_item_text(index))
		
		get_node("/root/LevelEditor/Camera2D/Control").setFile(self.get_item_text(index))
		
		# so it doesnt save changes through loading, which would be weird
		get_parent().get_parent().processChange()
