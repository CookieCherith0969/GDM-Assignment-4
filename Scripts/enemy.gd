extends CharacterBody2D

var speed = 50 # Enemy speed -R
var player_in_range = false # If enemy is chasing player -R
var player = null # Player object -R
var lighters : Array = []
@onready
var sprite = $AnimatedSprite2D
@onready
var huntlight = $HuntLight
@export
var home_hive : Node2D = null
@onready
var nav_agent = $NavigationAgent2D
#var target_position = global_position
#const desired_distance = 5

func _ready():
	sprite.play("placeHolderAnim")
	
func _physics_process(delta):
	# Move towards player if in range and the players light is on OR a lamp plant is on -R
	if (player_in_range && player.lit):
		huntlight.enabled = true
		nav_agent.target_position = player.global_position
	elif lighters.size() > 0:
		huntlight.enabled = true
		
		var closest_lighter = lighters[0]
		var shortest_distance = global_position.distance_to(closest_lighter.global_position)
		for lighter in lighters:
			var distance = global_position.distance_to(lighter.global_position)
			if distance < shortest_distance:
				closest_lighter = lighter
				shortest_distance = distance
		
		nav_agent.target_position = closest_lighter.global_position
	else:
		huntlight.enabled = false
		if home_hive:
			nav_agent.target_position = home_hive.global_position
		else:
			nav_agent.target_position = global_position
	
	if nav_agent.is_navigation_finished():
		return
	
	#if global_position.distance_to(target_position) < desired_distance:
	#	return
	
	velocity = global_position.direction_to(nav_agent.get_next_path_position())*speed
	#velocity = global_position.direction_to(target_position)*speed
	# Flip sprite horizontally to face player -R
	if (velocity.x) < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	move_and_slide()

# If a plant in the scene is on, set activeLampPlant to true otherwise, false -R
"""func checkForActivePlants():
	for x in lampPlantsInScene:
		if x.lampActive:
				activeLampPlant = true
				return
		else:
			activeLampPlant = false"""
		


func _on_detection_area_target_entered(target):
	if not is_instance_of(target, Player):
		return
	player = target
	player_in_range = true


func _on_detection_area_target_exited(target):
	if not is_instance_of(target, Player):
		return
	player = null
	player_in_range = false

func on_lit(lighter):
	lighters.push_back(lighter)

func on_unlit(lighter):
	lighters.erase(lighter)
