extends Control



func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/StartMenu.tscn")


func _on_lvl_0_pressed():
	SoundManager.start_ambient()
	LevelManager.load_level("Tutorial")


func _on_lvl_1_pressed():
	SoundManager.start_ambient()
	LevelManager.load_level("BatteryLevel")


func _on_lvl_2_pressed():
	SoundManager.start_ambient()
	LevelManager.load_level("LampLevel")


func _on_lvl_3_pressed():
	SoundManager.start_ambient()
	LevelManager.load_level("DavidLevel")


func _on_lvl_4_pressed():
	SoundManager.start_ambient()
	LevelManager.load_level("KynanLevel")
