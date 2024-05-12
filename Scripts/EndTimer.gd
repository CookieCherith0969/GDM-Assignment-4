extends Timer

@onready
var elevator = $"../Elevator"

var shaking = false

func _process(_delta):
	if not shaking:
		if PlayerManager.shake_camera(6,15,wait_time,0.3,0):
			shaking = true

func _on_timeout():
	elevator.queue_free()
	PlayerManager.current_player.queue_free()
	await get_tree().create_timer(3).timeout
	LevelManager.load_level("Credits",false)
