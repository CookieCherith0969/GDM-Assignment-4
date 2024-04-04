extends CharacterBody2D

var lampActive = false

# Start with lamp off -R
func _ready():
	$AnimatedSprite2D.play("off") 

# When player enters range turn lamp on -R
func _on_detection_area_body_entered(body):
	if not is_instance_of(body, Player):
		return
	$AnimatedSprite2D.play("on")
	lampActive = true

# When player leaves wait x seconds then turn off -R
func _on_detection_area_body_exited(body):
	if not is_instance_of(body, Player):
		return
	await get_tree().create_timer(3).timeout
	$AnimatedSprite2D.play("off")
	lampActive = false
