extends Control



func _on_back_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("StartMenu", false)
