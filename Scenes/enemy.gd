extends CharacterBody2D

var speed = 50 # Enemy speed -R
var player_in_range = false # If enemy is chasing player -R
var player = null # Player object -R

# Enemy physics process
func _physics_process(delta):
	# Play default animation always -R
	if !$AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("placeHolderAnim")
	# Move towards player if in range and light is on -R
	if (player_in_range && player.light.process_mode != Node.PROCESS_MODE_DISABLED):
		position += (player.position - position).normalized() * speed * delta
		# Flip sprite horizontally to face player -R
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

# When player enters detection area -R
func _on_detection_area_body_entered(body):
	player = body
	player_in_range = true

# When player leaves detection area -R
func _on_detection_area_body_exited(_body):
	player = null
	player_in_range = false
