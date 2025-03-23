extends Node2D

var rng = RandomNumberGenerator.new()

var levelEditor = preload("res://Scenes/LevelEditor.tscn").instantiate()
func changeToLevelEditor():
	# hide old scene
	self.visible = false
	
	# add level editor scene
	get_tree().root.add_child(levelEditor)
	
	#self.get_node("Character").get_node("Camera2D")
	
	# sets the level editors camera to the current one
	levelEditor.get_node("Camera2D").make_current()
	
	# turn off character movement
	get_node("Character").setPaused(true)
	
func newLevel():
	var files = DirAccess.get_files_at("res://Levels/Game")
	
	get_node("TileMapLayer").loadLevel(files[rng.randi_range(0,files.size() - 1)].get_basename())
	
func changeToMainGame():
	newLevel()
	
	get_node("LevelEditorCollision").queue_free()
	get_node("MainGameCollision").queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var editorFunc = Callable.create(self, "changeToLevelEditor")
	var gameFunc = Callable.create(self, "changeToMainGame")
	
	self.get_node("LevelEditorCollision").get_node("Area2D").setFunction(editorFunc)
	self.get_node("MainGameCollision").get_node("Area2D").setFunction(gameFunc)
