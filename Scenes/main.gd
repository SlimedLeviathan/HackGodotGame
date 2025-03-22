extends Node2D

func changeToLevelEditor():
	print("Change")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var function = Callable.create(self, "changeToLevelEditor")
	
	self.get_node("LevelEditorCollision").get_node("Area2D").setFunction(function)

	function.call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
