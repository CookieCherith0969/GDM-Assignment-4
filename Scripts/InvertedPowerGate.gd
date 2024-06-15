@tool
extends StaticBody2D

@export
var power_id := 0
@export
var start_powered = false : set = set_start_powered
@onready var gate_open = $gateOpen
@onready var gate_close = $gateClose

@onready
var shape = $CollisionShape2D
@onready
var sprite = $Sprite2D
@onready
var occluder = $LightOccluder2D
var id : int = 0 : set = set_id
var registered = false

var player_inside = false : set = set_player_inside

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		power_id = power_id
		start_powered = start_powered
	else:
		id = power_id
		if start_powered:
			on_power()

func set_id(val : int):
	if not registered:
		id = val
		PowerManager.register_powerable(self, id)
		registered = true
		return
	
	PowerManager.deregister_powerable(self, id)
	id = val
	PowerManager.register_powerable(self, id)

func set_start_powered(val : bool):
	start_powered = val
	if not is_instance_valid(sprite):
		return
	
	if start_powered:
		sprite.show()
	else:
		sprite.hide()

func on_power():
	if not player_inside:
		shut_gate()

func on_depower():
	open_gate()

func open_gate():
	shape.set_deferred("disabled", true)
	gate_open.play()
	sprite.hide()
	occluder.hide()

func shut_gate():
	shape.set_deferred("disabled", false)
	gate_close.play()
	sprite.show()
	occluder.show()

func set_player_inside(val):
	player_inside = val
	
	if not player_inside and PowerManager.is_powered(id):
		shut_gate()

func _on_area_2d_body_entered(body):
	if is_instance_of(body, Player):
		player_inside = true


func _on_area_2d_body_exited(body):
	if is_instance_of(body, Player):
		player_inside = false
