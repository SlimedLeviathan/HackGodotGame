extends Button

var isUp = false

func _on_pressed() -> void:
	if not isUp:
		isUp = true
		
		var saveControl = get_parent().get_node("SaveControl")
		
		var tween = saveControl.create_tween()
		
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		
		tween.tween_property(saveControl, "position", Vector2(saveControl.position.x, 0), 1)
		get_parent().get_node("LoadControl").hideThis()
	
	else:
		get_parent().get_node("SaveControl").hideThis()
