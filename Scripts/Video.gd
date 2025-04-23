extends Control

@onready
var fullscreen_text = $FullscreenText

@onready var crt_checkbox = $CRTCheckbox
@onready var crt_overlay = $CRTOverlay

func _ready():
	crt_checkbox.set_pressed_no_signal(SaveManager.crt_enabled)

func _input(event):
	if event.is_action_pressed("Menu"):
		SoundManager.menu_button()
		LevelManager.load_level("Settings",false)

func _on_back_pressed():
	SaveManager.save_settings()
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

func _on_crt_toggle_button_pressed():
	SaveManager.crt_enabled = !SaveManager.crt_enabled
	crt_checkbox.set_pressed_no_signal(SaveManager.crt_enabled)
	if SaveManager.crt_enabled:
		crt_overlay.show()
	else:
		crt_overlay.hide()
