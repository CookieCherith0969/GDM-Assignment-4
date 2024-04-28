extends Node

var powerables : Array = []

var power_levels : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func register_powerable(powerable, id):
	while powerables.size() < id+1:
		powerables.append([])
	powerables[id].append(powerable)
	
func deregister_powerable(powerable, id):
	powerables[id].erase(powerable)

func clear_powerables():
	powerables.clear()

func increase_power(id):
	while power_levels.size() < id+1:
		power_levels.append(0)
	power_levels[id]+=1
	
	if power_levels[id] > 0:
		powerables.all(func(a): a.on_power())
	
func decrease_power(id):
	power_levels[id]-=1
	
	if power_levels[id] <= 0:
		powerables.all(func(a): a.on_depower())
