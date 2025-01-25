extends Control


func _on_btn_return_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
