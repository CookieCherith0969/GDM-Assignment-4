@tool
class_name Elevator
extends Area2D

@export
var next_level_name : String
@export
var closed : bool = false : set = set_closed
@export
var is_start : bool = false : set = set_start
@export
var power_id : int = 0
var id : int = 0 : set = set_id
var registered = false

@onready
var open_sprite = preload("res://Art/PlaceholderArt/ElevatorOpen.png")
@onready
var closed_sprite = preload("res://Art/PlaceholderArt/ElevatorClosed.png")

@onready
var sprite = $Sprite2D
@onready
var door_body = $DoorBody
@onready
var close_sound = $Close
@onready
var open_sound = $Open
@onready
var elevHum = $Hum

var player_inside = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		closed = closed
		power_id = power_id
	else:
		closed = closed
		id = power_id

func set_closed(val : bool):
	closed = val
	
	if not is_instance_valid(sprite):
		return
	
	if closed:
		if !Engine.is_editor_hint():
			close_sound.play()
			if player_inside:
				elevHum.play()
		sprite.texture = closed_sprite
		door_body.process_mode = Node.PROCESS_MODE_INHERIT
		door_body.show()
	else:
		if !Engine.is_editor_hint():
			open_sound.play()
		sprite.texture = open_sprite
		door_body.process_mode = Node.PROCESS_MODE_DISABLED
		door_body.hide()

func set_id(val : int):
	if not registered:
		id = val
		PowerManager.register_powerable(self, id)
		registered = true
		return
	
	PowerManager.deregister_powerable(self, id)
	id = val
	PowerManager.register_powerable(self, id)

func force_next():
	LevelManager.load_level(next_level_name, false)

func _on_door_area_body_exited(body):
	if closed:
		return
	if is_instance_of(body, Player):
		if is_start and !player_inside:
			closed = true
		elif !is_start and player_inside:
			closed = true
			if next_level_name:
				LevelManager.load_level(next_level_name, true)

func _on_body_entered(body):
	if is_instance_of(body, Player):
		player_inside = true

func _on_body_exited(body):
	if is_instance_of(body, Player):
		player_inside = false

func on_power():
	closed = false

func on_depower():
	closed = true

func set_start(val : bool):
	is_start = val
	player_inside = is_start
