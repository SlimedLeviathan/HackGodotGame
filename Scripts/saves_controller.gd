# this file will handle what file is open currently, and if to delete it
extends Control

var currentFile = ""
var timeSinceChange = -1

# wow were actually gonna use this
func _process(delta: float) -> void:
	if timeSinceChange != -1 and currentFile != "":
		if timeSinceChange > 0:
			timeSinceChange -= delta
		elif timeSinceChange <= 0:
			saveLevel()
		

func processChange():
	timeSinceChange = 5 # if the user makes no changes in 5 seconds, the file will save

func setFile(name):
	currentFile = name

func deleteCurrentFile():
	if (currentFile != ""):
		# delete current file
		DirAccess.remove_absolute("res://Levels/User Levels/" + currentFile + ".txt")
		
	# no matter what, the tilemap should be cleared
	get_node("/root/LevelEditor/TileMapLayer").resetLevel()
	get_node("/root/LevelEditor/WireTileMapLayer").clear()
	
	currentFile = ""
	
	get_node("LoadControl/LevelList").setLevels()
	
func saveLevel():
	get_node("/root/LevelEditor/TileMapLayer").saveLevel(currentFile)
	
	# do a cute little save popup
	var savedLabel = get_node("SavedLabel")
	var tween = savedLabel.create_tween()
	
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(savedLabel, "position", Vector2(savedLabel.position.x, (get_window().size.y / 2) - savedLabel.size.y), 1)
	
	await create_tween().tween_interval(3).finished
	
	var second = savedLabel.create_tween()
	
	second.set_ease(Tween.EASE_OUT)
	second.set_trans(Tween.TRANS_BACK)
	second.tween_property(savedLabel, "position", Vector2(savedLabel.position.x, (get_window().size.y) / 1.25), 1.5)

# just easy implementation
func _on_delete_button_pressed() -> void:
	deleteCurrentFile()

func _on_done_button_pressed() -> void:
	
	var main = get_node("/root/Main")
	
	# remove old scene
	main.visible = true
	
	# remove level editor from the tree
	get_tree().root.remove_child(self.get_parent().get_parent())
	
	var character = main.get_node("Character")
	
	# sets the level editors camera to the current one
	character.get_node("Camera2D").make_current()
	
	# turn on character movement
	character.setPaused(false)
