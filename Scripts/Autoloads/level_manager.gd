extends Node

var current_level = null
var current_name = null
@onready
var root = get_tree().root

var prev_data_logs_read = 0
var data_logs_read = 0
var data_logs_read_current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = root.get_child(root.get_child_count() - 1)
	current_name = "Tutorial"

func load_level(level_name : String, transition : bool):
	PowerManager.clear_all()
	PlayerManager.save_player_state()
	call_deferred("_deferred_load_level", level_name, transition)

func _deferred_load_level(level_name : String, transition : bool):
	var spawn_pos = Vector2(0,0)
	var elevator_rot = PI/2
	if current_level.has_method("get_end_elevator") and PlayerManager.has_player():
		var end_pos = current_level.get_end_elevator().global_position
		var player_pos = PlayerManager.current_player.global_position
		spawn_pos = player_pos - end_pos
		elevator_rot = current_level.get_end_elevator().rotation
	current_level.free()
	if current_name == level_name:
		spawn_pos = Vector2(0,0)
		PlayerManager.reset_player_state()
		data_logs_read_current_level = 0
	else:
		data_logs_read += data_logs_read_current_level
		data_logs_read_current_level = 0
	if transition:
		current_name = "TransitionElevator"
		var elevator_scene = ResourceLoader.load("res://Scenes/Levels/TransitionElevator.tscn")
		current_level = elevator_scene.instantiate()
		get_tree().root.add_child(current_level)
		get_tree().current_scene = current_level
		SoundManager.start_ambient()
		PlayerManager.place_player_at(spawn_pos)
		current_level.get_end_elevator().next_level_name = level_name
		current_level.get_end_elevator().rotation = elevator_rot
		return
	#get_tree().change_scene_to_file("res://Scenes/Levels/"+level_name+".tscn")
	var level_scene = ResourceLoader.load("res://Scenes/Levels/"+level_name+".tscn")
	current_level = level_scene.instantiate()
	current_name = level_name
	get_tree().root.add_child(current_level)
	get_tree().current_scene = current_level
	if current_level.has_method("get_start_elevator"):
		SoundManager.start_ambient()
		PlayerManager.place_player_at(current_level.get_start_elevator().global_position + spawn_pos)
		PlayerManager.place_failed_robot()
	else:
		SoundManager.start_music()
		if data_logs_read > prev_data_logs_read:
			prev_data_logs_read = data_logs_read
		data_logs_read = 0
		data_logs_read_current_level = 0

func reload_level():
	PowerManager.clear_all()
	PlayerManager.save_player_pos()
	if current_name == "TransitionElevator":
		var next_name = current_level.get_end_elevator().next_level_name
		load_level(next_name, true)
	else:
		load_level(current_name, false)
