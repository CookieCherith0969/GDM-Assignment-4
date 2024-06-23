extends CharacterBody2D
class_name ParticleEnemy

var speed = 150 # Enemy speed -R
var player = null
var player_in_range = false : set = set_player_in_range
var player_lit = false : set = set_player_lit
var player_corrupted = false : set = set_player_corrupted
var target = null : set = set_target
var hunting = false : set = set_hunting
var lighters : Array = []
@onready
var huntlight = $HuntLight
@export
var home_hive : Node2D = null : set = set_hive
@onready
var nav_agent = $NavigationAgent2D
var nav_ready = false
var player_loaded = false
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

const detection_range = 100
var player_is_lighter = false
var player_was_lighter = false
var player_was_was_lighter = false

func _ready():
	EnemyManager.deregistered_active.connect(_on_deregistered_active)
	$DetectionArea.ray_range = detection_range
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
	if not player_loaded:
		player = PlayerManager.current_player
		player.lit_changed.connect(_on_player_lit_changed)
		player.corruption_toggled.connect(_on_player_corruption_toggled)
		player_lit = player.lit
		player_loaded = true
	
	if player_was_lighter or player_was_was_lighter:
		#print_debug("light target override")
		target = player
	else:
		try_target_player()
	player_was_was_lighter = player_was_lighter
	player_was_lighter = player_is_lighter
	
	if target.global_position != nav_agent.target_position:
		nav_agent.target_position = target.global_position
	
	if !hunting:
		# Cool down while at home
		if at_home:
			if reaction_timer > 0:
				reaction_timer -= delta
			if reaction_timer < 0:
				reaction_timer = 0
		elif nav_agent.is_navigation_finished():
			EnemyManager.deregister_active(self)
			at_home = true
	else:
		# After finding a target, freeze until the reaction timer is finished
		if reaction_timer <= reaction_time:
			reaction_timer += delta
			if reaction_timer < reaction_time:
				return
	
	
	if hunting or (!at_home and target == home_hive):
		var next_pos = nav_agent.get_next_path_position()
		# Move towards target position
		velocity = global_position.direction_to(next_pos)*speed
		#print_debug(velocity)
		move_and_slide()

func set_hive(val):
	home_hive = val
	if target == null:
		target = home_hive

func set_hunting(val):
	hunting = val
	if hunting:
		at_home = false

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

func set_target(val):
	target = val
	#print_debug(target)
	if not is_instance_valid(nav_agent):
		return
	nav_agent.target_position = target.global_position
	if target == home_hive:
		hunting = false
	else:
		hunting = EnemyManager.try_register_active(self)

func _on_deregistered_active():
	if target != home_hive:
		hunting = EnemyManager.try_register_active(self)

func _on_detection_area_target_entered(detection_target):
	if not is_instance_of(detection_target, Player):
		return
	player_in_range = true

func _on_detection_area_target_exited(detection_target):
	if not is_instance_of(detection_target, Player):
		return
	player_in_range = false

func _on_player_lit_changed(lit):
	player_lit = lit

func _on_player_corruption_toggled(corrupted):
	player_corrupted = corrupted

func set_player_lit(val):
	player_lit = val
	try_target_player()

func set_player_in_range(val):
	player_in_range = val
	try_target_player()

func set_player_corrupted(val):
	player_corrupted = val
	try_target_player()

func try_target_player():
	#print_debug(player_corrupted)
	if player_lit and player_in_range and !player_corrupted:
		target = player
		#print_debug("Player targeted")
	elif target == player:
		#print_debug("Trying to untarget Player")
		if lighters.has(player):
			return
		target = home_hive
		target_closest_lighter()
		
		#print_debug("Player untargeted")

func set_reaction_timer(val):
	reaction_timer = val
	
	var aggravation = reaction_timer/reaction_time
	huntlight.energy = aggravation*max_light_energy
	set_particle_speed(lerp(slow_particle_speed,fast_particle_speed,aggravation))

func on_lit(lighter):
	if is_instance_of(lighter, ParticleEnemy):
		return
	print_debug("Enemy lit")
	#if lighter.has_method("is_corrupted") and lighter.is_corrupted():
	#	return
	lighters.push_back(lighter)
	if lighter == player:
		if !player_corrupted:
			target = player
			player_is_lighter = true
		return
	
	if target != player:
		target_closest_lighter()

func on_unlit(lighter):
	if is_instance_of(lighter, ParticleEnemy):
		return
	print_debug("Enemy unlit")
	lighters.erase(lighter)
	
	if lighter == player:
		player_is_lighter = false
	if lighter == target:
		target = home_hive
		#print_debug("Lighter untargeted")
	if target != player:
		target_closest_lighter()

func target_closest_lighter():
	if lighters.is_empty():
		return
	var closest_lighter = lighters[0]
	var shortest_distance = global_position.distance_to(closest_lighter.global_position)
	for lighter in lighters:
		var distance = global_position.distance_to(lighter.global_position)
		if distance < shortest_distance:
			closest_lighter = lighter
			shortest_distance = distance
	
	target = closest_lighter
	if target == player:
		player_is_lighter = true
	#print_debug("Lighter targeted")

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
