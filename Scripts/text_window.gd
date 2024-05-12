extends MarginContainer

var contents : String = "" : set = set_contents

@onready
var text = $Control/MarginContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func close():
	GuiManager.hide_window()

func set_contents(val : String):
	contents = val
	text.text = contents


func _on_button_pressed():
	close()
	PlayerManager.current_player.free_controls()
