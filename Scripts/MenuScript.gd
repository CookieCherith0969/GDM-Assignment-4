extends Control
@onready var click = $click


func _on_credits_button_pressed():
	SoundManager.menu_button()
	get_tree().change_scene_to_file("res://Scenes/Levels/Credits.tscn")

func _on_play_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Tutorial")
	


func _on_level_button_pressed():
	SoundManager.menu_button()
	get_tree().change_scene_to_file("res://Scenes/Levels/LevelSelect.tscn")
	
