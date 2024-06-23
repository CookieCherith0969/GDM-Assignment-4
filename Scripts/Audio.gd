extends Control

@onready
var sliders = [
	$VBoxContainer/MasterSlider,
	$VBoxContainer/PlayerSlider,
	null,
	$VBoxContainer/CreaturesSlider,
	$VBoxContainer/PlantsSlider,
	$VBoxContainer/MachinesSlider,
	$VBoxContainer/MusicSlider,
	$VBoxContainer/AmbienceSlider
]

func _ready():
	for i in range(AudioServer.bus_count):
		if(i==2):
			continue
		sliders[i].value = db_to_linear(AudioServer.get_bus_volume_db(i))*100

func _on_back_pressed():
	SaveManager.save_settings()
	SoundManager.menu_button()
	LevelManager.load_level("Settings",false)


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value/100))

func _on_player_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value/100))

func _on_creatures_slider_value_changed(value):
	AudioServer.set_bus_volume_db(3, linear_to_db(value/100))

func _on_plants_slider_value_changed(value):
	AudioServer.set_bus_volume_db(4, linear_to_db(value/100))

func _on_machines_slider_value_changed(value):
	AudioServer.set_bus_volume_db(5, linear_to_db(value/100))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(6, linear_to_db(value/100))

func _on_ambience_slider_value_changed(value):
	AudioServer.set_bus_volume_db(7, linear_to_db(value/100))
