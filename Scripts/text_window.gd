extends MarginContainer

var contents : String = "" : set = set_contents

@onready
var text = $Control/MarginContainer/RichTextLabel

func close():
	GuiManager.hide_window()

func set_contents(val : String):
	contents = val
	text.text = contents


func _on_button_pressed():
	close()
	PlayerManager.current_player.free_controls()
