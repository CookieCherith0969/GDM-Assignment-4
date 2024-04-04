class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready
var light = $LightArea
var light_on = true

func _input(event):
	if event.is_action_pressed("Light"):
		if not light_on:
			light_on = true
			light.monitoring = true
			light.show()
		else:
			light_on = false
			light.monitoring = false
			light.hide()

func _physics_process(_delta):
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
	
	rotation += get_angle_to(get_global_mouse_position())
	
	

	move_and_slide()
