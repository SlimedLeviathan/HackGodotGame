extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var enterFunc = null

func setFunction(function:Callable):
	enterFunc = function

func _on_body_entered(body: Node2D) -> void:
	if enterFunc != null:
		enterFunc.call()
