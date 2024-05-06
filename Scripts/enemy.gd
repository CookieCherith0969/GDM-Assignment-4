extends CharacterBody2D

var speed = 110 # Enemy speed -R
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
var nav_ready = false
var at_home = true

var shuffle_timer = 0
var shuffle_frequency = 2
var current_shuffle_frequency = 0
var reaction_time = 0.5
var reaction_timer = 0
#var target_position = global_position
#const desired_distance = 5

func _ready():
	sprite.play("placeHolderAnim")
	call_deferred("nav_setup")
	
func nav_setup():
	await get_tree().physics_frame
	nav_ready = true
	
func _physics_process(delta):
	if not nav_ready:
		return
	# Move towards player if in range and the players light is on OR a lamp plant is on -R
	if (player_in_range && player.lit && !player.is_corrupted):
		at_home = false
		current_shuffle_frequency = 0
		huntlight.enabled = true
		nav_agent.target_position = player.global_position
	elif lighters.size() > 0:
		at_home = false
		current_shuffle_frequency = 0
		huntlight.enabled = true
		
		var closest_lighter = lighters[0]
		var shortest_distance = global_position.distance_to(closest_lighter.global_position)
		for lighter in lighters:
			var distance = global_position.distance_to(lighter.global_position)
			if distance < shortest_distance:
				closest_lighter = lighter
				shortest_distance = distance
		
		nav_agent.target_position = closest_lighter.global_position
	elif not at_home:
		huntlight.enabled = false
		if home_hive:
			nav_agent.target_position = home_hive.global_position
		else:
			nav_agent.target_position = global_position
	elif home_hive:
		shuffle_timer += delta
		if shuffle_timer > current_shuffle_frequency:
			shuffle_timer -= current_shuffle_frequency
			current_shuffle_frequency = randfn(shuffle_frequency, 0.5)
			nav_agent.target_position = home_hive.global_position + Vector2.from_angle(randf_range(0,2*PI))*randfn(13,5)
	
	if nav_agent.is_navigation_finished():
		if home_hive and nav_agent.target_position == home_hive.global_position:
			at_home = true
			reaction_timer = 0
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	
	#if global_position.distance_to(target_position) < desired_distance:
	#	return
	if not at_home:
		reaction_timer += delta
		if reaction_timer < reaction_time:
			return
	
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
	if lighter.has_method("is_corrupted") and lighter.is_corrupted():
		return
	lighters.push_back(lighter)

func on_unlit(lighter):
	if lighter.has_method("is_corrupted") and lighter.is_corrupted():
		return
	lighters.erase(lighter)

func _on_kill_area_body_entered(body):
	if is_instance_of(body, Player):
		LevelManager.reload_level()
