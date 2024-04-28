extends Node

var current_level = null
var current_name = null
@onready
var root = get_tree().root
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = root.get_child(root.get_child_count() - 1)
	current_name = "Tutorial"

func load_level(level_name : String):
	PowerManager.clear_all()
	current_name = level_name
	call_deferred("_deferred_load_level", level_name)

func _deferred_load_level(level_name : String):
	get_tree().change_scene_to_file("res://Scenes/Levels/"+level_name+".tscn")

func reload_level():
	load_level(current_name)
