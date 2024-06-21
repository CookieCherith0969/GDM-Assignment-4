extends CharacterBody2D

var speed = 150 # Enemy speed -R
var player_in_range = false # If enemy is chasing player -R
var player = null # Player object -R
var lighters : Array = []
@onready
var huntlight = $HuntLight
@export
var home_hive : Node2D = null
@onready
var nav_agent = $NavigationAgent2D
var nav_ready = false
var at_home = true : set = set_at_home
@onready var buzzing = $buzzing

@onready
var collider = $CollisionShape2D

var particles := []

var shuffle_timer = 0
var shuffle_frequency = 2
var current_shuffle_frequency = 0
var reaction_time = 0.5
var reaction_timer = 0 : set = set_reaction_timer
#const desired_distance = 5

var particle_push_force = 5
var slow_particle_speed = 60
var fast_particle_speed = 300

var max_light_energy = 0.5

var on_screen = false

var in_final_cutscene = false : set = set_final_cutscene

var prev_player_dist = 1000

func _ready():
	for particle in $Particles.get_children():
		particles.append(particle)
		particle.position.x += randf_range(-2,2)
		particle.position.y += randf_range(-2,2)
		particle.speed = slow_particle_speed


func _physics_process(delta):
	if not nav_ready:
		nav_ready = true
		return
	
	if in_final_cutscene:
		update_particles(delta)
		return
	
	if on_screen:
		update_particles(delta)
	
	if not PlayerManager.has_player():
		return
	player = PlayerManager.current_player
	var player_dist = global_position.distance_to(player.global_position) - collider.shape.radius
	# If the player is a valid target, prioritise them
	if player_in_range && player.lit && !player.is_corrupted():
		at_home = false
		
		nav_agent.target_position = player.global_position
	
	elif (player_dist <= player.glow_area.ray_range or prev_player_dist <= player.glow_area.ray_range) and !player.is_corrupted():
		at_home = false
		
		nav_agent.target_position = player.global_position
	
	# If the player isn't a target, but there's something else casting light on the scout, target it
	elif lighters.size() > 0:
		at_home = false
		
		var closest_lighter = lighters[0]
		var shortest_distance = global_position.distance_to(closest_lighter.global_position)
		for lighter in lighters:
			var distance = global_position.distance_to(lighter.global_position)
			if distance < shortest_distance:
				closest_lighter = lighter
				shortest_distance = distance
		
		nav_agent.target_position = closest_lighter.global_position
	
	# No valid targets, but not at home. Return home.
	elif not at_home:
		nav_agent.target_position = home_hive.global_position
		
	prev_player_dist = player_dist
	
	# Cool down while at home
	if at_home:
		if reaction_timer > 0:
			reaction_timer -= delta
			if reaction_timer < 0:
				reaction_timer = 0
	
	if nav_agent.is_navigation_finished():
		if home_hive and nav_agent.target_position == home_hive.global_position:
			at_home = true
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	
	# After finding a target, freeze until the reaction timer is finished
	if not at_home and reaction_timer <= reaction_time:
		reaction_timer += delta
		if reaction_timer < reaction_time:
			return
	var next_pos = nav_agent.get_next_path_position()
	# Move towards target position
	velocity = global_position.direction_to(next_pos)*speed
	
	#if get_parent().name == "Hive4":
		#print_debug(str(velocity.normalized())+" Towards "+str(global_position.direction_to(nav_agent.target_position)))

	move_and_slide()

func update_particles(delta):
	for particle in particles:
		var dist = particle.position.length()
		if dist < 0.5:
			particle.velocity += particle.position.normalized()*delta*particle_push_force
			pass
		else:
			particle.velocity += -particle.position*delta*dist
		#particle.global_position = particle.global_position.move_toward(global_position, particle_chase_speed*delta)

func set_particle_speed(particle_speed):
	for particle in particles:
		particle.speed = particle_speed

func set_final_cutscene(val):
	in_final_cutscene = val
	
	if in_final_cutscene:
		reaction_timer = reaction_time
		buzzing.play()
	else:
		reaction_timer = 0
		buzzing.stop()

func set_at_home(val : bool):
	at_home = val
	if not at_home and not buzzing.playing:
		buzzing.play()
	elif at_home and buzzing.playing:
		buzzing.stop()

func _on_detection_area_target_entered(target):
	if not is_instance_of(target, Player):
		return
	player_in_range = true

func set_reaction_timer(val):
	reaction_timer = val
	
	var aggravation = reaction_timer/reaction_time
	huntlight.energy = aggravation*max_light_energy
	set_particle_speed(lerp(slow_particle_speed,fast_particle_speed,aggravation))

func _on_detection_area_target_exited(target):
	if not is_instance_of(target, Player):
		return
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
		if body.is_corrupted():
			return
		SoundManager.play_death()
		LevelManager.reload_level()


func _on_particle_enabler_screen_entered():
	for particle in particles:
		particle.process_mode = PROCESS_MODE_INHERIT
	on_screen = true

func _on_particle_enabler_screen_exited():
	for particle in particles:
		particle.process_mode = PROCESS_MODE_DISABLED
	on_screen = false
