extends Control

func _input(event):
	if event.is_action_pressed("Menu"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		elif !OS.has_feature("Web"):
			get_tree().quit()
func _ready():
	PlayerManager.reset_player_state()

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
