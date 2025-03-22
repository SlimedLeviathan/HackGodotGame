extends TextEdit

func _on_text_changed() -> void:
	if (text.length() > 0 and text[-1] == "\n"):
		text = text.substr(0, text.length() - 1)
		
		# honestly we dont need this, but i like it
		self.set_caret_column(text.length())
		
		get_node("/root/LevelEditor/TileMapLayer").saveLevel(text)
		
		get_node("/root/LevelEditor/Camera2D/Control").setFile(text)
		
		get_parent().hideThis()
		
		text = ""
		
		get_parent().get_parent().get_node("LoadControl/LevelList").setLevels()
