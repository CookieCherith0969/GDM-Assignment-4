extends Control



func _on_back_pressed():
	SoundManager.menu_button()
	get_tree().change_scene_to_file("res://Scenes/Levels/StartMenu.tscn")


func _on_lvl_0_pressed():
	SoundManager.menu_button()
	SoundManager.start_ambient()
	LevelManager.load_level("Tutorial")


func _on_lvl_1_pressed():
	SoundManager.menu_button()
	SoundManager.start_ambient()
	LevelManager.load_level("BatteryLevel")


func _on_lvl_2_pressed():
	SoundManager.menu_button()
	SoundManager.start_ambient()
	LevelManager.load_level("LampLevel")


func _on_lvl_3_pressed():
	SoundManager.menu_button()
	SoundManager.start_ambient()
	LevelManager.load_level("DavidLevel")


func _on_lvl_4_pressed():
	SoundManager.menu_button()
	SoundManager.start_ambient()
	LevelManager.load_level("KynanLevel")
