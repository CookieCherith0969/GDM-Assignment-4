extends CanvasModulate

@export
var disable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !disable:
		show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
