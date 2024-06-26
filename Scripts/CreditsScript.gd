extends Control

func _input(event):
	if event.is_action_pressed("Menu"):
		SoundManager.menu_button()
		LevelManager.load_level("StartMenu",false)

func _on_back_button_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("StartMenu", false)
