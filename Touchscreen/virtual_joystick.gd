@tool
extends Control

@export_category("Input Actions")
@export var x_negative: StringName = ""
@export var x_positive: StringName = ""
@export var y_negative: StringName = ""
@export var y_positive: StringName = ""

@export_category("Joystick Properties")
@export var max_distance: float = 20.0:
	set(value):
		max_distance = value
		if !is_node_ready():
			await ready
		if !joystick_held:
			joystick_head.shape.radius = max_distance
		queue_redraw()
@export var base_color: Color = Color.GRAY:
	set(value):
		base_color = value
		queue_redraw()
@export var head_radius: float = 8.0:
	set(value):
		head_radius = value
		if !is_node_ready():
			await ready
		joystick_head.head_radius = head_radius
		if joystick_held:
			joystick_head.shape.radius = head_radius
@export var head_color: Color = Color.BLACK:
	set(value):
		head_color = value
		if !is_node_ready():
			await ready
		joystick_head.head_color = head_color

@onready var joystick_head: TouchScreenButton = $JoystickHead

var joystick_held: bool = false
var rest_position: Vector2

func _ready() -> void:
	rest_position = joystick_head.position

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if joystick_held:
		joystick_head.global_position = get_global_mouse_position()
	
	var offset: Vector2 = joystick_head.global_position - global_position - rest_position
	if offset.length() > max_distance:
		offset = offset.limit_length(max_distance)
		joystick_head.global_position = global_position + rest_position + offset 
	var input = offset / max_distance
	if input.x < 0.0:
		Input.action_press(x_negative,abs(input.x))
		Input.action_press(x_positive,0.0)
	else:
		Input.action_press(x_positive,abs(input.x))
		Input.action_press(x_negative,0.0)
	if input.y < 0.0:
		Input.action_press(y_negative,abs(input.y))
		Input.action_press(y_positive,0.0)
	else:
		Input.action_press(y_negative,0.0)
		Input.action_press(y_positive,abs(input.y))

func _draw() -> void:
	draw_circle(Vector2.ZERO,max_distance,base_color)

func _on_joystick_pressed() -> void:
	joystick_held = true
	joystick_head.shape.radius = head_radius

func _on_joystick_released() -> void:
	joystick_held = false
	joystick_head.position = rest_position
	joystick_head.shape.radius = max_distance
