extends Node

@onready
var player_scene = preload("res://Scenes/player.tscn")
@onready
var failed_robot_scene = preload("res://Scenes/failed_robot.tscn")
@onready
var failed_robots_node = $FailedRobots
var current_player : Player = null
var camera : Camera2D = null

var was_light_on = false
var had_battery = false
#var was_corrupted = false
var was_moving_left = false
var was_moving_up = false

var prev_player_positions = []
var prev_left_facings = []
const max_failed_robots = 6


var shake_str = 0.0
var shake_spd = 0.0
var shake_dur = 0.0
var shake_time = 0.0
var shake_fade_in = 0.0
var shake_fade_out = 0.0

var _noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	_noise.seed = randi()
	_noise.fractal_octaves = 4
	_noise.frequency = 1.0 / 20.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_time > 0:
		if !is_instance_valid(camera):
			shake_time = 0.0
			return
		shake_time -= delta
		if shake_time < 0:
			camera.position = Vector2(0,0)
			return
		var progress = shake_dur - shake_time
		var shakeX = _noise.get_noise_2d(progress*shake_spd,0)
		var shakeY = _noise.get_noise_2d(0,progress*shake_spd)
		var effective_strength = shake_str
		if progress < shake_fade_in:
			effective_strength *= progress/shake_fade_in
		elif shake_time < shake_fade_out:
			effective_strength *= shake_time/shake_fade_out
		
		camera.position.x = shakeX * effective_strength
		camera.position.y = shakeY * effective_strength

func save_player_state():
	if is_instance_valid(current_player):
		was_light_on = current_player.light_on
		#was_corrupted = current_player.corrupted
		was_moving_left = current_player.moving_left
		was_moving_up = current_player.moving_up

func place_player_at(pos : Vector2):
	if is_instance_valid(current_player):
		current_player.queue_free()
	
	var new_player = player_scene.instantiate()
	new_player.position = pos
	new_player.moving_left = was_moving_left
	new_player.moving_up = was_moving_up
	LevelManager.current_level.add_child(new_player)
	new_player.light_on = was_light_on
	#new_player.corrupted = was_corrupted

func has_player():
	return is_instance_valid(current_player)

func reset_player_state():
	was_light_on = false
	#was_corrupted = false
	was_moving_left = false
	was_moving_up = false
	
func shake_camera(strength : float, speed : float, duration : float, fade_in_time : float = 0.0, fade_out_time : float = 0.0):
	if !is_instance_valid(camera):
		return false
	
	camera.position = Vector2(0,0)
	shake_str = strength
	shake_spd = speed
	shake_dur = duration
	shake_fade_in = fade_in_time
	shake_fade_out = fade_out_time
	shake_time = shake_dur
	return true

func save_player_pos():
	if is_instance_valid(current_player):
		prev_player_positions.append(current_player.position)
		prev_left_facings.append(current_player.moving_left)
		
		if prev_player_positions.size() >= max_failed_robots:
			prev_player_positions.pop_front()
			prev_left_facings.pop_front()

func clear_prev_positions():
	prev_player_positions.clear()
	prev_left_facings.clear()
	for robot in failed_robots_node.get_children():
		robot.queue_free()

func place_failed_robots():
	for robot in failed_robots_node.get_children():
		robot.queue_free()
	
	for i in range(prev_player_positions.size()):
		var prev_pos = prev_player_positions[i]
		var prev_left = prev_left_facings[i]
		
		var new_failed = failed_robot_scene.instantiate()
		new_failed.position = prev_pos
		new_failed.flip_h = prev_left
		failed_robots_node.add_child(new_failed)
