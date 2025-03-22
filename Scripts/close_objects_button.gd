extends Button

var isClosed = false

func _on_pressed() -> void:
	isClosed = not isClosed
	
	var parent = get_parent()
	var tween = parent.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	
	if (isClosed):
		# move the menu to the left
		self.text = "<"
		
		tween.tween_property(parent, "position", Vector2(get_parent().get_node("ItemList").size.x,0), 1)
		
		#get_parent().set_position(Vector2(get_parent().get_node("ItemList").size.x,0))
	else:
		self.text = ">"
		#move menu to the right, back into view
		tween.tween_property(parent, "position", Vector2(0,0), 1)
