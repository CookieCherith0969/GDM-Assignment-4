extends Control

@export
var log_labels : Array[Node]

func _ready():
	for i in range(log_labels.size()):
		var logs_read = LevelManager.num_read_logs(LevelManager.data_logs_read[i])
		var max_logs = LevelManager.max_data_logs[i]
		log_labels[i].text = str(logs_read)+"/"+str(max_logs)

func _input(event):
	if event.is_action_pressed("Menu"):
		SoundManager.menu_button()
		LevelManager.load_level("StartMenu",false)

func _on_back_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("StartMenu", false)


func _on_lvl_0_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("Tutorial", true)


func _on_lvl_1_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("BatteryLevel", true)


func _on_lvl_2_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("LampLevel", true)


func _on_lvl_3_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("VentLevel", true)


func _on_lvl_4_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("ButtonLevel", true)


func _on_final_lvl_pressed():
	SoundManager.menu_button()
	LevelManager.load_level("FinalLevel", true)
