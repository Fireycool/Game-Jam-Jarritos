extends Node2D

const SPEED = 350

func _process(delta:float) -> void:
	var axis = Input.get_axis("left","right")
	position.x += axis * SPEED * delta
	
	
