extends Control



func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Credits.tscn")


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Tutorial.tscn")



func _on_level_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/LevelSelect.tscn")
