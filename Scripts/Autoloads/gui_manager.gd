extends CanvasLayer

@onready
var window = $TextWindow
@onready
var paper = $paperSound
var open_pitch = 1.0
var close_pitch = 0.7

func show_window(contents : String):
	window.show()
	window.contents = contents
	PlayerManager.current_player.exited.connect(hide_window)
	paper.pitch_scale = open_pitch
	paper.play()
	await paper.finished
	AudioServer.set_bus_mute(0, true)

func hide_window():
	window.hide()
	AudioServer.set_bus_mute(0, false)
	paper.pitch_scale = close_pitch
	paper.play()
	PlayerManager.current_player.exited.disconnect(hide_window)
