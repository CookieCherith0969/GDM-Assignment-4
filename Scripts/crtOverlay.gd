extends CanvasLayer

@export
var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !SaveManager.crt_enabled:
		hide()
	else:
		visible = !disabled
