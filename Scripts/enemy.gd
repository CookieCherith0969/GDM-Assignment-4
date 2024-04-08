extends CharacterBody2D

var speed = 50 # Enemy speed -R
var player_in_range = false # If enemy is chasing player -R
var player = null # Player object -R
var activeLampPlant = false
var lampPlantsInScene = null
@onready
var sprite = $AnimatedSprite2D
@onready
var huntlight = $HuntLight

func _ready():
	pass
	# Get all lamp plants in scene -R
	#lampPlantsInScene = get_tree().get_nodes_in_group("LampPlants")
# Enemy physics process -R
func _physics_process(delta):
	#checkForActivePlants()
	# Play default animation always -R
	if !sprite.is_playing():
		sprite.play("placeHolderAnim")
	# Move towards player if in range and the players light is on OR a lamp plant is on -R
	if (player_in_range && player.lit):
		huntlight.enabled = true
		velocity = position.direction_to(player.position) * speed
		# Flip sprite horizontally to face player -R
		if (player.position.x - position.x) < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		move_and_slide()
	else:
		huntlight.enabled = false

# When player enters detection area -R
func _on_detection_area_body_entered(body):
	if not is_instance_of(body, Player):
		return
	player = body
	player_in_range = true

# When player leaves detection area -R
func _on_detection_area_body_exited(body):
	if not is_instance_of(body, Player):
		return
	player = null
	player_in_range = false

# If a plant in the scene is on, set activeLampPlant to true otherwise, false -R
"""func checkForActivePlants():
	for x in lampPlantsInScene:
		if x.lampActive:
				activeLampPlant = true
				return
		else:
			activeLampPlant = false"""
		
