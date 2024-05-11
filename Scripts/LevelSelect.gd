extends Control



func _on_back_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("StartMenu", false)


func _on_lvl_0_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Tutorial", true)


func _on_lvl_1_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("BatteryLevel", true)


func _on_lvl_2_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("LampLevel", true)


func _on_lvl_3_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("DavidLevel", true)


func _on_lvl_4_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("KynanLevel", true)
