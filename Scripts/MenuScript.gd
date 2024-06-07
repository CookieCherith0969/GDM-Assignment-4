extends Control


func _on_credits_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Credits", false)

func _on_play_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Tutorial", true)

func _on_level_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("LevelSelect", false)

func _on_settings_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Settings", false)
