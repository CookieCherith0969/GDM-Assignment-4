extends Node

var current_level = null
var current_name = null
@onready
var root = get_tree().root

@onready
var levels : Dictionary = {
	"StartMenu": preload("res://Scenes/Levels/StartMenu.tscn"),
	"LevelSelect": preload("res://Scenes/Levels/LevelSelect.tscn"),
	"Settings": preload("res://Scenes/Levels/Settings.tscn"),
	"Audio": preload("res://Scenes/Levels/Audio.tscn"),
	"Credits": preload("res://Scenes/Levels/Credits.tscn"),
	"TransitionElevator": preload("res://Scenes/Levels/TransitionElevator.tscn"),
	"Tutorial": preload("res://Scenes/Levels/Tutorial.tscn"),
	"BatteryLevel": preload("res://Scenes/Levels/BatteryLevel.tscn"),
	"LampLevel": preload("res://Scenes/Levels/LampLevel.tscn"),
	"VentLevel": preload("res://Scenes/Levels/VentLevel.tscn"),
	"ButtonLevel": preload("res://Scenes/Levels/ButtonLevel.tscn"),
	"FinalLevel": preload("res://Scenes/Levels/FinalLevel.tscn"),
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
	
	

#LOADING LEVEL TASKS
#- Reset Power Manager
#- Get Player position relative to previous elevator
#- Remove Current Level
#- Create new level

#NEW LEVEL TASKS
#- Save Player State
#- Persist Player State

#RELOAD LEVEL TASKS
#- Reset Player State

#TRANSITION TASKS
#- Set next level
#- Set elevator rotation
	
func reload_level():
	if current_name == "TransitionElevator":
		return
		#var next_name = current_level.get_end_elevator().next_level_name
		#load_level(next_name, true)
	PowerManager.clear_all()
	PlayerManager.save_player_pos()
	PlayerManager.reset_player_state()
	call_deferred("_deferred_reload_level")

func _deferred_reload_level():
	current_level.free()
	instantiate_new_level(current_name)
	PlayerManager.place_player_at(current_level.get_start_elevator().global_position)
	PlayerManager.place_failed_robot()


func load_level(level_name : String, transition : bool):
	PowerManager.clear_all()
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
	
	if transition:
		instantiate_new_level("TransitionElevator")
		SoundManager.start_ambient()
		PlayerManager.place_player_at(spawn_pos)
		current_level.get_end_elevator().next_level_name = level_name
		current_level.get_end_elevator().rotation = elevator_rot
		return
	
	instantiate_new_level(level_name)
	
	#Menu scenes have no start elevator
	if not current_level.has_method("get_start_elevator"):
		SoundManager.start_music()
		return
	
	SoundManager.start_ambient()
	PlayerManager.place_player_at(current_level.get_start_elevator().global_position + spawn_pos)
	PlayerManager.place_failed_robot()

func instantiate_new_level(level_name : String):
	var level_scene = levels[level_name]
	current_level = level_scene.instantiate()
	current_name = level_name
	get_tree().root.add_child(current_level)
	get_tree().current_scene = current_level
