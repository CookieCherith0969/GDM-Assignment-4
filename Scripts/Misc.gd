extends Control

@onready
var clear_text = $ClearText

func _on_back_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Settings", false)

func _on_clear_button_pressed():
	LevelManager.clear_data_logs()
	clear_text.show()
	await get_tree().create_timer(1.5).timeout
	clear_text.hide()
