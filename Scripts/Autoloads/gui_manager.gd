extends CanvasLayer

@onready
var window = $TextWindow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_window(contents : String):
	window.show()
	window.contents = contents
	AudioServer.set_bus_mute(0, true)
	PlayerManager.current_player.exited.connect(hide_window)

func hide_window():
	window.hide()
	AudioServer.set_bus_mute(0, false)
	PlayerManager.current_player.exited.disconnect(hide_window)
