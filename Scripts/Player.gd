class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready
var flasharea = $Rotator/FlashArea
@onready
var edgearea = $Rotator/EdgeArea

@onready
var flashlight = $Rotator/FlashLight 
var light_on = false : set = set_light_on

@onready
var glowlight = $GlowLight

@onready
var rotator = $Rotator

var num_lights = 0 : set = set_lights
var lit = false

var has_key = false

func _input(event):
	if event.is_action_pressed("Light"):
		if not light_on:
			light_on = true
		else:
			light_on = false
			

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal = Input.get_axis("Left", "Right")
	var vertical = Input.get_axis("Up", "Down")
	var direction = Vector2(horizontal, vertical).normalized()
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	rotator.rotation = get_angle_to(get_global_mouse_position())
	move_and_slide()

func _on_InteractArea_body_entered(body): # Colliding with objects
	if body.is_in_group("Keys") and not has_key:
		body.queue_free()
		has_key = true
	elif body.is_in_group("Doors") and has_key:
		body.get_node("CollisionShape2D").disabled = true

func on_lit():
	num_lights += 1
	
func on_unlit():
	num_lights -= 1
	
func set_lights(val : int):
	num_lights = val
	if num_lights == 0:
		lit = false
	else:
		lit = true
	print_debug(num_lights)

func set_light_on(val : bool):
	if light_on != val:
		light_on = val
		if light_on:
			on_lit()
			flasharea.active = true
			edgearea.active = true
			flashlight.enabled = true
		else:
			on_unlit()
			flasharea.active = false
			edgearea.active = false
			flashlight.enabled = false
