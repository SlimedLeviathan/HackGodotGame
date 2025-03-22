extends Button

var isUp = false

func _on_pressed() -> void:
	if not isUp:
		isUp = true
		
		var loadControl = get_parent().get_node("LoadControl")
		
		var tween = loadControl.create_tween()
		
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		
		tween.tween_property(loadControl, "position", Vector2(loadControl.position.x, 0), 1)
		
		get_parent().get_node("SaveControl").hideThis()
	else:
		get_parent().get_node("LoadControl").hideThis()
