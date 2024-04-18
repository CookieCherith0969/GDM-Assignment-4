@tool
extends Node2D

@export_range(0,360)
var angle : float = 360 : set = set_angle
@export_range(2,200)
var num_rays : int = 5 : set = set_rays
@export_range(0.05, 500)
var range : float = 20 : set = set_range
@export
var active = true : set = set_active
@export
var hit_from_inside = false : set = set_inside

var rays : Array
var targets : Array
var prev_targets : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	angle = angle
	num_rays = num_rays
	range = range
	active = active


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not active:
		return

	prev_targets = targets.duplicate()
	targets.clear()
	
	for ray in rays:
		ray.clear_exceptions()
		ray.force_raycast_update()
		while ray.is_colliding():
			var target = ray.get_collider()
			if is_instance_of(target, TileMap):
				break
			if (not target in targets) and (target.has_method(&"on_lit")):
				targets.append(target)
				if not target in prev_targets:
					target.on_lit()
			if target.get_collision_layer_value(1):
				break
			else:
				ray.add_exception(target)
			ray.force_raycast_update()
	
	for target in prev_targets:
		if not target in targets:
			target.on_unlit()

func set_angle(val : float):
	angle = val

	var i : float = 0
	for ray in rays:
		ray.rotation_degrees = (i/(num_rays-1) * angle)-(angle/2)
		i += 1
	

func set_rays(val : int):
	num_rays = val
	
	rays.clear()
	for child in get_children():
		child.queue_free()
	
	for i in range(num_rays):
		var new_ray := RayCast2D.new()
		new_ray.enabled = false
		new_ray.set_collision_mask_value(4, true)
		new_ray.target_position.y = -range
		new_ray.rotation_degrees = ((float(i)/(num_rays-1)) * angle)-(angle/2)
		new_ray.hit_from_inside = hit_from_inside
		rays.append(new_ray)
		add_child(new_ray)
	
func set_range(val : float):
	range = val
	
	for ray in rays:
		ray.target_position.y = -range

func set_active(val : bool):
	active = val
	
	if not active:
		for target in targets:
			target.on_unlit()
		targets.clear()

func set_inside(val : bool):
	hit_from_inside = val
	
	for ray in rays:
		ray.hit_from_inside = hit_from_inside
