extends Node2D

@onready var gui = $Camera2D/GUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_timer()
	$Player/AudioStreamPlayer2D.play()
	pass # Replace with function body.

func level_win():
	gui.win()

func level_lose():
	gui.lose()
	
