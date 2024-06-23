extends Node2D

var lampActive = false : set = set_active
@onready
var timer = $Timer
@onready
var sprite = $AnimatedSprite2D
@onready
var glowarea = $GlowArea
@onready
var glowlight = $GlowLight
@onready var plantlight = $PlantLight
@onready
var active_sound = $ActiveSound

func _ready():
	sprite.play("off") # Start with lamp off -R

func _process(_delta):
	if lampActive:
		if not active_sound.playing:
			active_sound.play()
	else:
		if active_sound.playing:
			active_sound.stop()

# When player enters range turn lamp on and stop any previous timer -R
func _on_detection_area_body_entered(body):
	if not is_instance_of(body, Player):
		return
	sprite.play("on")
	lampActive = true
	plantlight.play()
	timer.stop()

# When player leaves start timer -R
func _on_detection_area_body_exited(body):
	if not is_instance_of(body, Player):
		return
	timer.start()

# When timer runs out, turn off the plant -R
func _on_timer_timeout():
	sprite.play("off")
	lampActive = false

func set_active(val : bool):
	if lampActive != val:
		lampActive = val
		if lampActive:
			glowarea.active = true
			glowlight.enabled = true
		else:
			glowarea.active = false
			glowlight.enabled = false
	
