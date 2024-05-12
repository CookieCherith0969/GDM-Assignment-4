extends CanvasLayer

@export
var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = !disabled
