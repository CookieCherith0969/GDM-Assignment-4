extends Timer

@onready
var elevator = $"../Elevator"
@onready
var floors_label = $"../RemainingFloors"

var shaking = false

func _ready():
	elevator.close_sound.play()
	elevator.elevHum.play()
	await LevelManager.level_setup
	var index = LevelManager.index_of_name(elevator.next_level_name)
	index -= LevelManager.num_menus
	var remaining_floors = LevelManager.num_levels - index - 1
	
	var floor_text = "Floor" if remaining_floors == 1 else "Floors"
	floors_label.text = str(remaining_floors)+" "+floor_text+" to Anomaly"

func _process(_delta):
	if not shaking:
		if PlayerManager.shake_camera(3,15,wait_time,0.3,0.3):
			shaking = true

func _on_timeout():
	elevator.force_next()
