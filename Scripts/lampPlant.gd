extends CharacterBody2D

var lampActive = false
@onready
var timer = $Timer
@onready
var sprite = $AnimatedSprite2D
@onready
var light = $LightArea

func _ready():
	sprite.play("off") # Start with lamp off -R
	
# When player enters range turn lamp on and stop any previous timer -R
func _on_detection_area_body_entered(body):
	if not is_instance_of(body, Player):
		return
	sprite.play("on")
	lampActive = true
	light.show()
	light.monitoring = true
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
	light.hide()
	light.monitoring = false


func _on_light_area_body_entered(body):
	if body.has_method(&"on_lit"):
		body.on_lit()


func _on_light_area_body_exited(body):
	if body.has_method(&"on_unlit"):
		body.on_unlit()
