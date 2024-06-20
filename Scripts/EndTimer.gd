extends Timer

@onready
var elevator = $"../Elevator"

var shaking = false
var corrupted = false

func _ready():
	elevator.close_sound.play()
	elevator.elevHum.play()

func _process(_delta):
	if not shaking:
		if PlayerManager.shake_camera(6,15,wait_time,0.3,0):
			shaking = true
	if corrupted:
		return
	var player = PlayerManager.current_player
	if is_instance_valid(player):
		player.corrupted = true
		corrupted = true

func _on_timeout():
	elevator.queue_free()
	PlayerManager.current_player.queue_free()
	await get_tree().create_timer(3).timeout
	LevelManager.load_level("Credits",false)
