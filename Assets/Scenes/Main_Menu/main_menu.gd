extends Control

func _on_btn_how_2_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/How_To_Play/how2play.tscn")

func _on_btn_exit_pressed() -> void:
	get_tree().quit()

func _on_btn_play_pressed() -> void:
	Global.reset_timer()
	get_tree().change_scene_to_file("res://Assets/Scenes/level_1/level_1.tscn")
