class_name Player
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready
var flasharea = $Rotator/FlashArea

@onready
var flashlight = $Rotator/FlashLight 
var light_on = false : set = set_light_on

@onready var light_on_audio = $LightOn
@onready var light_off_audio = $LightOff
@onready var walking = $Walking
@onready var timer = $Timer


@onready
var glowlight = $GlowLight

@onready
var rotator = $Rotator

var num_lights = -1 : set = set_lights
var lit = false

var has_key = false

func _input(event):
	if event.is_action_pressed("Light"):
		if not light_on:
			light_on = true
		else:
			light_on = false
	if event.is_action_pressed("Reset"):
		LevelManager.reload_level()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction:
		velocity = direction * SPEED
		if timer.time_left <= 0:
			walking.pitch_scale = randf_range(0.7, 1.2)
			walking.play()
			timer.start(0.3)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	#rotator.rotation = get_angle_to(get_global_mouse_position())
	move_and_slide()

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
