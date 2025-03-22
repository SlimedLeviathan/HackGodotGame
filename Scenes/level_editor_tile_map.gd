extends TileMapLayer

var selectedBlock = [0,0,1]
var leftPressed = false
var rightPressed = false

var extraPos = [0,0]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var position = event.position - Vector2(viewport.get_window().size.x / 2,viewport.get_window().size.y / 2)
	
	position -= Vector2(extraPos[0], extraPos[1])
	
	var coords = local_to_map(to_local(position))
	
	if is_instance_of(event, InputEventMouseButton):
		if event.is_pressed():
			if event.button_index == 1:
				self.set_cell(coords, selectedBlock[2], Vector2i(selectedBlock[0], selectedBlock[1]))
				
				leftPressed = true
			elif event.button_index == 2:
				rightPressed = true
		else:
			leftPressed = false
			rightPressed = false
		
	elif leftPressed:
		self.set_cell(coords, selectedBlock[2], Vector2i(selectedBlock[0], selectedBlock[1]))
	
	elif rightPressed:
		extraPos[0] += event.relative[0]
		extraPos[1] += event.relative[1]
		
		self.get_parent().get_node("Camera2D").offset.x = -extraPos[0]
		self.get_parent().get_node("Camera2D").offset.y = -extraPos[1]
		
