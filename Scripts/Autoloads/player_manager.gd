extends Node

@onready
var player_scene = preload("res://Scenes/player.tscn")

var current_player : Player = null
var camera : Camera2D = null

var was_light_on = false
var had_battery = false
var was_corrupted = false

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
		print_debug("shaking")
		if !is_instance_valid(camera):
			print_debug("Ending shaking, no camera")
			shake_time = 0.0
		shake_time -= delta
		if shake_time < 0:
			print_debug("Ending shaking, time out")
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
