extends Node

signal level_setup

var current_level = null
var current_name = null
@onready
var root = get_tree().root
const num_menus = 5
const num_levels = 6
var is_loading = false

@onready
var levels : Dictionary = {
	#Menus
	"StartMenu": preload("res://Scenes/Levels/StartMenu.tscn"),
	"LevelSelect": preload("res://Scenes/Levels/LevelSelect.tscn"),
	"Settings": preload("res://Scenes/Levels/Settings.tscn"),
	"Audio": preload("res://Scenes/Levels/Audio.tscn"),
	"Credits": preload("res://Scenes/Levels/Credits.tscn"),
	#Levels
	"Tutorial": preload("res://Scenes/Levels/Tutorial.tscn"),
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
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false
]

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = root.get_child(root.get_child_count() - 1)
	current_name = "StartMenu"
	
func index_of_name(name : String):
	return levels.keys().find(name)
	
func reload_level():
	if is_loading:
		return
	is_loading = true
	if current_name == "TransitionElevator":
		return
		#var next_name = current_level.get_end_elevator().next_level_name
		#load_level(next_name, true)
	PlayerManager.save_player_pos()
	PlayerManager.reset_player_state()
	call_deferred("_deferred_reload_level")

func _deferred_reload_level():
	var checkpoint_id = current_level.current_checkpoint
	current_level.free()
	PowerManager.clear_all()
	EnemyManager.reset()
	instantiate_new_level(current_name)
	if checkpoint_id < 0:
		PlayerManager.place_player_at(current_level.get_start_elevator().global_position)
	else:
		var checkpoint = current_level.checkpoints[checkpoint_id]
		checkpoint.reset_level()
		PlayerManager.place_player_at(checkpoint.global_position)
	PlayerManager.place_failed_robot()
	level_setup.emit()
	is_loading = false


func load_level(level_name : String, transition : bool):
	if is_loading:
		return
	is_loading = true
	PlayerManager.save_player_state()
	call_deferred("_deferred_load_level", level_name, transition)

func _deferred_load_level(level_name : String, transition : bool):
	var spawn_pos = Vector2(0,0)
	var elevator_rot = PI/2
	if PlayerManager.has_player():
		var end_pos = current_level.get_end_elevator().global_position
		var player_pos = PlayerManager.current_player.global_position
		spawn_pos = player_pos - end_pos
		elevator_rot = current_level.get_end_elevator().rotation
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
	
	#Menu scenes have no start elevator
	if not current_level.has_method("get_start_elevator"):
		SoundManager.start_music()
		is_loading = false
		return
	
	SoundManager.start_ambient()
	PlayerManager.place_player_at(current_level.get_start_elevator().global_position + spawn_pos)
	level_setup.emit()
	is_loading = false

func instantiate_new_level(level_name : String):
	var level_scene = levels[level_name]
	current_level = level_scene.instantiate()
	current_name = level_name
	get_tree().root.add_child(current_level)
	get_tree().current_scene = current_level
