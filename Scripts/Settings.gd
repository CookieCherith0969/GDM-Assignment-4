extends Control

func _on_audio_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Audio",false)

func _on_back_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("StartMenu",false)

func _on_misc_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Misc",false)
