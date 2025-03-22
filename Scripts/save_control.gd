extends Control

func hideThis():	
	var tween = self.create_tween()
	
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(self, "position", Vector2(self.position.x, get_window().size.y / 1.5), 1)
	
	get_parent().get_node("SaveButton").isUp = false
