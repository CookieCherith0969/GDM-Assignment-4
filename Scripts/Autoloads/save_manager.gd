extends Node

var save_path = "user://settings"

const num_buses = 8
var crt_enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		for i in range(AudioServer.bus_count):
			AudioServer.set_bus_volume_db(i, file.get_float())
		if file.get_length() > AudioServer.bus_count*4:
			crt_enabled = file.get_var()
		file.close()
	else:
		for i in range(AudioServer.bus_count):
			AudioServer.set_bus_volume_db(i, linear_to_db(0.5))
	AudioServer.set_bus_volume_db(2,0)

func save_settings():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	for i in range(AudioServer.bus_count):
		file.store_float(AudioServer.get_bus_volume_db(i))
	file.store_var(crt_enabled)
	file.close()
