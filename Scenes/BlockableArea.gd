@tool
extends Node2D

signal target_entered(target)
signal target_exited(target)

@export_range(0,360)
var angle : float = 360 : set = set_angle
@export_range(2,500)
var num_rays : int = 5 : set = set_rays
@export_range(0.05, 500)
var ray_range : float = 20 : set = set_range
@export
var active = true : set = set_active
@export
var hit_from_inside = false : set = set_inside
@export
var ray_mask : int = 1 : set = set_mask

var rays : Array
var targets : Array
var prev_targets : Array

var active_targets : Array

func get_targets():
	return active_targets

# Called when the node enters the scene tree for the first time.
func _ready():
	active = active
	angle = angle
	num_rays = num_rays
	ray_range = ray_range
	hit_from_inside = hit_from_inside
	ray_mask = ray_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if rays.size() == 0:
		return
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
					active_targets.append(target)
					target_entered.emit(target)
			if target.get_collision_layer_value(1):
				break
			else:
				ray.add_exception(target)
			ray.force_raycast_update()
	
	for target in prev_targets:
		if not target in targets:
			active_targets.erase(target)
			target_exited.emit(target)

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
		new_ray.target_position.y = -ray_range
		new_ray.rotation_degrees = ((float(i)/(num_rays-1)) * angle)-(angle/2)
		new_ray.hit_from_inside = hit_from_inside
		rays.append(new_ray)
		add_child(new_ray)
	
func set_range(val : float):
	ray_range = val
	
	for ray in rays:
		ray.target_position.y = -ray_range

func set_active(val : bool):
	active = val
	
	if not active:
		for target in active_targets:
			target_exited.emit(target)
		active_targets.clear()
		targets.clear()
		prev_targets.clear()

func set_inside(val : bool):
	hit_from_inside = val
	
	for ray in rays:
		ray.hit_from_inside = hit_from_inside

func set_mask(val : int):
	ray_mask = val
	
	for ray in rays:
		ray.collision_mask = ray_mask
