extends Timer

@onready
var elevator = $"../Elevator"

var shaking = false

func _ready():
	elevator.close_sound.play()
	elevator.elevHum.play()

func _process(_delta):
	if not shaking:
		if PlayerManager.shake_camera(3,15,wait_time,0.3,0.3):
			shaking = true

func _on_timeout():
	elevator.force_next()
