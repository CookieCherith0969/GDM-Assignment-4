class_name Player
extends CharacterBody2D

const SPEED = 100.0
const CORRUPT_SPEED = 60.0

signal interacted(player)
signal exited

@onready
var flasharea = $Rotator/FlashArea

@onready
var flashlight = $Rotator/FlashLight 
var light_on = false : set = set_light_on

@onready var light_on_audio = $LightOn
@onready var light_off_audio = $LightOff
@onready var walking = $Walking
@onready var timer = $Timer
#@onready var pickup = $pickup

@onready
var robot_sprite = $RobotSprite
@onready
var glowlight = $GlowLight
@onready
var battery_sprite = $BatterySprite
@onready
var corruption_sprite = $CorruptionSprite

@onready
var normal_spriteframes = preload("res://Resources/playerAnimation.tres")
@onready
var corrupted_spriteframes = preload("res://Resources/playerAnimationCorrupt.tres")

@onready
var rotator = $Rotator
@onready
var glow_light = $GlowLight

var num_lights = -1 : set = set_lights
var lit = false

var has_key = false
var has_battery = false : set = set_battery

var corrupted = false : set = set_corrupted

var moving_up : bool = false
var moving_left : bool = false
var controls_locked : bool = false

func _ready():
	PlayerManager.current_player = self
	PlayerManager.camera = $Camera2D
	update_animation(false)

func _input(event):
	if event.is_action_pressed("Menu"):
		if controls_locked:
			#free_controls()
			exited.emit()
		else:
			LevelManager.load_level("StartMenu", false)
	if event.is_action_pressed("Light") && !controls_locked && !corrupted:
		if not light_on:
			light_on = true
		else:
			light_on = false
	if event.is_action_pressed("Reset"):
		if controls_locked:
			#free_controls()
			exited.emit()
		else:
			LevelManager.reload_level()
	if event.is_action_pressed("TempCorrupt"):
		corrupted = !corrupted
	if event.is_action_pressed("Interact"):
		if !controls_locked:
			interacted.emit(self)
		else:
			#free_controls()
			exited.emit()

func _physics_process(_delta):
	if controls_locked:
		update_animation(false)
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	var actual_speed = SPEED
	if corrupted:
		actual_speed = CORRUPT_SPEED
	if direction:
		velocity = direction * actual_speed
		if timer.time_left <= 0:
			walking.pitch_scale = randf_range(0.7, 1.2)
			walking.play()
			timer.start(0.5)
		moving_left = velocity.x < 0
		moving_up = velocity.y < 0
		update_animation(true)
		
	else:
		velocity.x = move_toward(velocity.x, 0, actual_speed)
		velocity.y = move_toward(velocity.y, 0, actual_speed)
		update_animation(false)
	
	#rotator.rotation = get_angle_to(get_global_mouse_position())
	move_and_slide()

func update_animation(moving : bool):
	if moving_left:
			robot_sprite.scale.x = -1
	else:
		robot_sprite.scale.x = 1
	if moving_up:
		if moving:
			robot_sprite.play("MoveUp")
		else:
			robot_sprite.play("IdleUp")
	else:
		if moving:
			robot_sprite.play("MoveDown")
		else:
			robot_sprite.play("IdleDown")

func on_lit(_lighter):
	num_lights += 1
	
	
func on_unlit(_lighter):
	num_lights -= 1
	
func set_lights(val : int):
	num_lights = val
	if num_lights == 0:
		lit = false
	else:
		lit = true

func set_light_on(val : bool):
	if light_on != val:
		light_on = val
		if light_on:
			light_on_audio.play()
			on_lit(self)
			flasharea.active = true
			flashlight.enabled = true
		else:
			light_off_audio.play()
			on_unlit(self)
			flasharea.active = false
			flashlight.enabled = false

func check_has_key() -> bool:
	return has_key

func set_key(value: bool):
	has_key = value


func _on_glow_area_target_entered(target):
	if target.has_method("on_lit"):
		target.on_lit(self)


func _on_glow_area_target_exited(target):
	if target.has_method("on_unlit"):
		target.on_unlit(self)

func is_corrupted():
	return corrupted

func set_battery(val : bool):
	has_battery = val
	#pickup.play()
	battery_sprite.visible = has_battery

func set_corrupted(val : bool):
	corrupted = val
	
	if corrupted:
		robot_sprite.sprite_frames = corrupted_spriteframes
		glow_light.texture_scale = 1
		glow_light.color = Color("e7b4f3")
	else:
		robot_sprite.sprite_frames = normal_spriteframes
		glow_light.texture_scale = 0.5
		glow_light.color = Color("ffb878")
	update_animation(false)

func free_controls():
	controls_locked = false
func lock_controls():
	controls_locked = true
