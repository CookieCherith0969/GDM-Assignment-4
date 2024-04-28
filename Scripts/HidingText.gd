extends Label

@export
var reveal_time = 2

@onready
var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_node("timer"):
		remove_child(get_node("timer"))
	timer.wait_time = reveal_time
	timer.one_shot = true
	timer.timeout.connect(on_timeout)
	timer.autostart = true
	add_child(timer)

func reveal():
	show()
	timer.start()

func on_timeout():
	hide()
