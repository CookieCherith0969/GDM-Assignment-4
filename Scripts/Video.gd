extends Control

@onready
var fullscreen_text = $FullscreenText

func _input(event):
	if event.is_action_pressed("Menu"):
		SoundManager.menu_button()
		LevelManager.load_level("Settings",false)

func _on_back_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Settings", false)

func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	fullscreen_text.show()
	await get_tree().create_timer(1.5).timeout
	fullscreen_text.hide()
