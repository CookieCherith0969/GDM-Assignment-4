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

var stick_timer = 0.0
const timer_frames = 3

var down = false
var held = false

func _process(delta):
	if !held and stick_timer > 0:
		stick_timer -= delta
		var progress = (stick_time-stick_timer)/stick_time
		var frame = progress*timer_frames
		sprite.frame = int(frame)
		
		if stick_timer <= 0:
			set_up()

func _on_body_entered(_body):
	set_down()
	held = true


func _on_body_exited(_body):
	stick_timer = stick_time
	held = false

func set_down():
	button_down.play()
	sprite.frame = 0
	if down:
		return
	down = true
	sprite.animation = "TimerDown"
	sprite.stop()
	sprite.frame = 0
	PowerManager.increase_power(id)

func set_up():
	if !down:
		return
	down = false
	sprite.play("TimerUp")
	button_up.play()
	PowerManager.decrease_power(id)
