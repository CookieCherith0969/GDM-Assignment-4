extends Node

signal level_setup

var current_level = null
var current_name = null
@onready
var root = get_tree().root
const num_menus = 6
const num_levels = 6
var is_loading = false

@onready
var levels : Dictionary = {
	#Menus
	"StartMenu": preload("res://Scenes/Levels/StartMenu.tscn"),
	"LevelSelect": preload("res://Scenes/Levels/LevelSelect.tscn"),
	"Settings": preload("res://Scenes/Levels/Settings.tscn"),
	"Audio": preload("res://Scenes/Levels/Audio.tscn"),
	"Misc": preload("res://Scenes/Levels/Misc.tscn"),
	"Credits": preload("res://Scenes/Levels/Credits.tscn"),
	#Levels
	"Tutorial": preload("res://Scenes/Levels/Tutorial.tscn"),
	#"Tutorial": preload("res://Scenes/Levels/test_scene.tscn"),
	"BatteryLevel": preload("res://Scenes/Levels/BatteryLevel.tscn"),
	"LampLevel": preload("res://Scenes/Levels/LampLevel.tscn"),
	"VentLevel": preload("res://Scenes/Levels/VentLevel.tscn"),
	"ButtonLevel": preload("res://Scenes/Levels/ButtonLevel.tscn"),
	"FinalLevel": preload("res://Scenes/Levels/FinalLevel.tscn"),
	#Transitions
	"TransitionElevator": preload("res://Scenes/Levels/TransitionElevator.tscn"),
	"EndScene": preload("res://Scenes/Levels/EndScene.tscn")
}

var data_logs_read = [
	[],
	[],
	[],
	[],
	[],
	[],
]

var max_data_logs = [
	2, #Tutorial
	2, #BatteryLevel
	2, #LampLevel
	2, #VentLevel
	2, #ButtonLevel
	1, #FinalLevel
]

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = root.get_child(root.get_child_count() - 1)
	current_name = "StartMenu"
	#debug_counter()

func debug_counter():
	while true:
		await get_tree().create_timer(1.0).timeout
		print_debug(recursive_count(root))

func recursive_count(node):
	var count = 1
	for child in node.get_children():
		count += recursive_count(child)
	return count

func index_of_name(level_name : String):
	return levels.keys().find(level_name)
	
func reload_level():
	if is_loading:
		return
	if index_of_name(current_name) > num_menus+num_levels-1:
		return
	is_loading = true
	
		#var next_name = current_level.get_end_elevator().next_level_name
		#load_level(next_name, true)
	GuiManager.hide_window()
	PlayerManager.save_player_pos()
	PlayerManager.reset_player_state()
	call_deferred("_deferred_reload_level")

func _deferred_reload_level():
	var checkpoint_id = current_level.current_checkpoint
	#var read_logs = num_read_logs(is_read_array)
	var index = index_of_name(current_name)-num_menus
	if index <= num_levels-1:
		data_logs_read[index] = current_level.get_logs_read()
	current_level.free()
	PowerManager.clear_all()
	EnemyManager.reset()
	instantiate_new_level(current_name)
	if index <= num_levels-1:
		current_level.set_logs_read(data_logs_read[index])
	if checkpoint_id < 0:
		PlayerManager.place_player_at(current_level.get_start_elevator().global_position)
	else:
		var checkpoint = current_level.checkpoints[checkpoint_id]
		checkpoint.reset_level()
		PlayerManager.place_player_at(checkpoint.global_position)
	PlayerManager.place_failed_robots()
	level_setup.emit()
	is_loading = false


func load_level(level_name : String, transition : bool):
	if is_loading:
		return
	is_loading = true
	PlayerManager.save_player_state()
	PlayerManager.clear_prev_positions()
	call_deferred("_deferred_load_level", level_name, transition)

func _deferred_load_level(level_name : String, transition : bool):
	var spawn_pos = Vector2(0,0)
	var elevator_rot = PI/2
	if PlayerManager.has_player():
		var end_pos = current_level.get_end_elevator().global_position
		var player_pos = PlayerManager.current_player.global_position
		spawn_pos = player_pos - end_pos
		elevator_rot = current_level.get_end_elevator().rotation
		
	var old_index = index_of_name(current_name)-num_menus
	if old_index >= 0 and old_index <= num_levels-1:
		data_logs_read[old_index] = current_level.get_logs_read()
	current_level.free()
	PowerManager.clear_all()
	EnemyManager.reset()
	
	if transition:
		instantiate_new_level("TransitionElevator")
		SoundManager.start_ambient()
		PlayerManager.place_player_at(spawn_pos)
		current_level.get_end_elevator().next_level_name = level_name
		current_level.get_end_elevator().rotation = elevator_rot
		level_setup.emit()
		is_loading = false
		return
	
	instantiate_new_level(level_name)
	
	#We treat menu scenes differently
	#Menu scenes have no start elevator
	if not current_level.has_method("get_start_elevator"):
		SoundManager.start_music()
		is_loading = false
		return
	
	var index = index_of_name(level_name)-num_menus
	if index <= num_levels-1:
		current_level.set_logs_read(data_logs_read[index])
	
	SoundManager.start_ambient()
	PlayerManager.place_player_at(current_level.get_start_elevator().global_position + spawn_pos)
	level_setup.emit()
	is_loading = false

func instantiate_new_level(level_name : String):
	var level_scene = levels[level_name]
	current_level = level_scene.instantiate()
	current_name = level_name
	root.add_child(current_level)
	get_tree().current_scene = current_level

func num_read_logs(is_read_array):
	var count = 0
	for is_read in is_read_array:
		if is_read:
			count += 1
	return count

func total_logs_read():
	var total = 0
	for is_read_array in data_logs_read:
		total += num_read_logs(is_read_array)
	return total

func total_max_logs():
	var total = 0
	for max_logs in max_data_logs:
		total += max_logs
	return total

func clear_data_logs():
	for i in range(data_logs_read.size()):
		data_logs_read[i] = []
