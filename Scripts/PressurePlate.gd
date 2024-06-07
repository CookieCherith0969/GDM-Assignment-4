extends Area2D

@export
var id = 1
@export
var stick_time = 1.0

@onready
var sprite = $AnimatedSprite2D
@onready
var button_down = $ButtonDown
@onready
var button_up = $ButtonUp

var stick_timer = 0

var down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("Up")

func _process(delta):
	if stick_timer > 0:
		stick_timer -= delta
		if stick_timer <= 0:
			set_up()

func _on_body_entered(_body):
	set_down()


func _on_body_exited(_body):
	stick_timer = stick_time

func set_down():
	button_down.play()
	if down:
		return
	down = true
	sprite.play("Down")
	PowerManager.increase_power(id)

func set_up():
	if !down:
		return
	down = false
	sprite.play("Up")
	button_up.play()
	PowerManager.decrease_power(id)
