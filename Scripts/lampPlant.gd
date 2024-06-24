extends Node2D

var lampActive = false : set = set_active
@onready
var timer = $Timer
var light_time = 3
var light_timer = 0
var held = false
@onready
var sprite = $AnimatedSprite2D
@onready
var glowarea = $GlowArea
@onready
var glowlight = $GlowLight
@onready var plantlight = $PlantLight
@onready
var active_sound = $ActiveSound
const timer_frames = 3

func _process(delta):
	if light_timer > 0:
		if not active_sound.playing:
			active_sound.play()
		if held:
			return
		light_timer -= delta
		
		if light_timer <= 0:
			sprite.play("off")
			lampActive = false
		else:
			var progress = (light_time-light_timer)/light_time
			var animation_num = int(progress*timer_frames)
			var frame = sprite.frame
			var frame_progress = sprite.frame_progress
			sprite.animation = "on"+str(animation_num)
			sprite.set_frame_and_progress(frame, frame_progress)
	else:
		if active_sound.playing:
			active_sound.stop()

# When player enters range turn lamp on and stop any previous timer -R
func _on_detection_area_body_entered(body):
	if not is_instance_of(body, Player):
		return
	held = true
	light_timer = light_time
	sprite.play("on0")
	lampActive = true
	plantlight.play()
#	timer.stop()

# When player leaves start timer -R
func _on_detection_area_body_exited(body):
	if not is_instance_of(body, Player):
		return
	held = false
	#timer.start()

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
	
