extends Timer

@onready
var elevator = $"../Elevator"

func _on_timeout():
	elevator.force_next()
