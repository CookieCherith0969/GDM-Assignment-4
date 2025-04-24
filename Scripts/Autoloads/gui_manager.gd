extends CanvasLayer

signal window_closed

@onready
var window = $TextWindow
@onready
var paper = $paperSound
var open_pitch = 1.0
var close_pitch = 0.7

@onready var in_level = $InLevel
@onready var touch_controls = $InLevel/TouchControls
@onready var interact_button = $InLevel/TouchControls/InteractButton

const touch_visibility_length: float = 5.0
var touch_visibility_timer: float = 0.0

func _ready():
	in_level.hide()
	touch_controls.hide()
	interact_button.hide()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		touch_controls.show()
		touch_visibility_timer = touch_visibility_length

func _process(delta):
	if touch_visibility_timer > 0.0:
		touch_visibility_timer -= delta
		if touch_visibility_timer <= 0.0:
			touch_controls.hide()

func show_window(contents : String):
	window.show()
	window.contents = contents
	paper.pitch_scale = open_pitch
	paper.play()
	#await paper.finished
	AudioServer.set_bus_mute(2, true)
	PlayerManager.current_player.exited.connect(hide_window)

func hide_window():
	window.hide()
	AudioServer.set_bus_mute(2, false)
	paper.pitch_scale = close_pitch
	PlayerManager.current_player.free_controls()
	if PlayerManager.current_player.exited.is_connected(hide_window):
		PlayerManager.current_player.exited.disconnect(hide_window)
		paper.play()
		window_closed.emit()

func hide_in_level_contents():
	in_level.hide()

func show_in_level_contents():
	in_level.show()

func show_interact_button():
	interact_button.show()

func hide_interact_button():
	interact_button.hide()
