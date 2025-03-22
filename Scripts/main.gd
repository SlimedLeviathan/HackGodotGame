extends Node2D

var levelEditor = preload("res://Scenes/LevelEditor.tscn").instantiate()
func changeToLevelEditor():
	# remove old scene
	self.visible = false
	
	# add level editor scene
	get_tree().root.add_child(levelEditor)
	
	#self.get_node("Character").get_node("Camera2D")
	
	# sets the level editors camera to the current one
	levelEditor.get_node("Camera2D").make_current()
	
	# turn off character movement
	get_node("Character").setPaused(true)
	
func changeToMainGame():
	print("Main Game Time!")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var editorFunc = Callable.create(self, "changeToLevelEditor")
	var gameFunc = Callable.create(self, "changeToMainGame")
	
	self.get_node("LevelEditorCollision").get_node("Area2D").setFunction(editorFunc)
	self.get_node("MainGameCollision").get_node("Area2D").setFunction(gameFunc)
