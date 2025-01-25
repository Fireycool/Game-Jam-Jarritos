extends Control



func _on_btn_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")


func _on_btn_how_2_play_pressed() -> void:
	get_tree().change_scene_to_file("res://how2play.tscn")


func _on_btn_exit_pressed() -> void:
	get_tree().quit()
