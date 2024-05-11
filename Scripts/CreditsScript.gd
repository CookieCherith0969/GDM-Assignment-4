extends Control



func _on_back_button_pressed():
	SoundManager.menu_button()
	get_tree().change_scene_to_file("res://Scenes/Levels/StartMenu.tscn")
