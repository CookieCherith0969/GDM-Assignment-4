@tool
extends Node2D

signal target_entered(target)
signal target_exited(target)

@export_range(0,360)
var angle : float = 360 : set = set_angle
@export_range(0.1,16)
var max_gap : float = 6 : set = set_gap
#@export_range(2,1000)
var num_rays : int = 5 : set = set_rays
@export_range(0.05, 500)
var ray_range : float = 20 : set = set_range
@export
var active = true : set = set_active
@export
var hit_from_inside = false : set = set_inside
@export_flags_2d_physics
var ray_mask : int = 1 : set = set_mask

var ray_rotations : Array
var targets : Array
@onready
var sweeping_ray = $SweepingRay

var active_targets : Array

func get_targets():
	return active_targets

# Called when the node enters the scene tree for the first time.
func _ready():
	active = active
	angle = angle
	max_gap = max_gap
	#num_rays = num_rays
	ray_range = ray_range
	hit_from_inside = hit_from_inside
	ray_mask = ray_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Engine.is_editor_hint():
		return
	if ray_rotations.size() == 0:
		return
	if not active:
		return
	targets.clear()
	
	sweeping_ray.clear_exceptions()
	for rot in ray_rotations:
		# Set the ray's target
		sweeping_ray.rotation = rot
		sweeping_ray.force_raycast_update()
		# Stop if the ray hit nothing
		while sweeping_ray.is_colliding():
			var collider = sweeping_ray.get_collider()
			# Stop if the ray hit a wall
			if is_instance_of(collider, TileMap):
				break
			
			# Exclude any non-wall object and cast again
			#ray.exclude.append(result.rid)
			sweeping_ray.add_exception(collider)
			targets.append(collider)
			sweeping_ray.force_raycast_update()
			
	
	for target in active_targets:
		if target not in targets:
			active_targets.erase(target)
			target_exited.emit(target)
	
	for target in targets:
		if target not in active_targets:
			active_targets.append(target)
			target_entered.emit(target)

func set_angle(val : float):
	angle = val
	
	max_gap = max_gap
	

func set_rays(val : int):
	num_rays = val
	
	ray_rotations.clear()
	
	for i in range(num_rays):
		var rot = deg_to_rad(((float(i)/(num_rays-1)) * angle)-(angle/2))
		ray_rotations.append(rot)
	
func set_range(val : float):
	ray_range = val
	if !is_instance_valid(sweeping_ray):
		return
	sweeping_ray.target_position = Vector2(0,-ray_range)
	
	max_gap = max_gap

func set_active(val : bool):
	active = val
	
	if not active:
		for target in active_targets:
			target_exited.emit(target)
		active_targets.clear()
		targets.clear()

func set_inside(val : bool):
	hit_from_inside = val
	if !is_instance_valid(sweeping_ray):
		return
	sweeping_ray.hit_from_inside = hit_from_inside

func set_mask(val : int):
	ray_mask = val
	if !is_instance_valid(sweeping_ray):
		return
	sweeping_ray.collision_mask = ray_mask

func set_gap(val : float):
	max_gap = val
	
	var circumference = 2*PI*ray_range * angle/360
	var min_rays = ceili(circumference/max_gap)
	if(min_rays < 2):
		min_rays = 2
	
	num_rays = min_rays
	
