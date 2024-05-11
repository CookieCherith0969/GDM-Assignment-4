extends Node

@onready
var player_scene = preload("res://Scenes/player.tscn")

var current_player : Player = null

var was_light_on = false
var had_battery = false
var was_corrupted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_player_state():
	if is_instance_valid(current_player):
		was_light_on = current_player.light_on
		was_corrupted = current_player.corrupted

func place_player_at(pos : Vector2):
	if is_instance_valid(current_player):
		current_player.queue_free()
	
	var new_player = player_scene.instantiate()
	new_player.position = pos
	LevelManager.current_level.add_child(new_player)
	new_player.light_on = was_light_on
	new_player.corrupted = was_corrupted

func has_player():
	return is_instance_valid(current_player)

func reset_player_state():
	was_light_on = false
	was_corrupted = false
