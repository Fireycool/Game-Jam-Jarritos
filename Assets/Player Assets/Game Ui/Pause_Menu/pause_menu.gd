extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func resume():
#
	#get_tree().paused = false
	#print(get_tree().paused)
#
#func pause():
	#get_tree().paused = false
	#print(get_tree().paused)
	#
#func testEsc():
	#if Input.is_action_just_pressed("pause") and get_tree().paused:
		#print(get_tree().paused)	
		#pause()
	#elif Input.is_action_just_pressed("pause") and get_tree().paused:
		#print(get_tree().paused)
		#resume()
	#
#
#func _on_continuar_pressed() -> void:
	#resume()
	#
#func _on_salir_pressed() -> void:
	#get_tree().change_scene_to_file("res://Assets/Scenes/Main_Menu/main_menu.tscn")
#
#func _process(delta):
	#testEsc()
