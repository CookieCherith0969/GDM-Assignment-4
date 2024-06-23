extends Node

var save_path = "user://settings"

const num_buses = 8


# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		for i in range(AudioServer.bus_count):
			AudioServer.set_bus_volume_db(i, file.get_float())
		file.close()
	else:
		for i in range(AudioServer.bus_count):
			AudioServer.set_bus_volume_db(i, linear_to_db(0.5))
	AudioServer.set_bus_volume_db(2,0)

func save_settings():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	for i in range(AudioServer.bus_count):
		file.store_float(AudioServer.get_bus_volume_db(i))
	file.close()
