extends CharacterBody2D

var lampActive = false
var timer = null

func _ready():
	$AnimatedSprite2D.play("off") # Start with lamp off -R
	timer = get_node("Timer") # Get timer -R
	
# When player enters range turn lamp on and stop any previous timer -R
func _on_detection_area_body_entered(body):
	if not is_instance_of(body, Player):
		return
	$AnimatedSprite2D.play("on")
	lampActive = true
	timer.stop()

# When player leaves start timer -R
func _on_detection_area_body_exited(body):
	if not is_instance_of(body, Player):
		return
	timer.start()

# When timer runs out, turn off the plant -R
func _on_timer_timeout():
	$AnimatedSprite2D.play("off")
	lampActive = false
