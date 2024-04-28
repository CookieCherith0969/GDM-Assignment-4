extends Node

var powerables : Array = []

var power_levels : Array = []

func register_powerable(powerable, id):
	while powerables.size() < id+1:
		powerables.append([])
	powerables[id].append(powerable)
	if is_powered(id):
		powerable.on_power()
	
func deregister_powerable(powerable, id):
	powerables[id].erase(powerable)
	if is_powered(id):
		powerable.on_depower()

func clear_all():
	power_levels.clear()
	powerables.clear()

func increase_power(id):
	while power_levels.size() <= id:
		power_levels.append(0)
	power_levels[id]+=1
	
	if powerables.size() <= id:
		return
	if power_levels[id] > 0:
		for powerable in powerables[id]:
			powerable.on_power()
		#powerables[id].all(func(a): a.on_power())
	
func decrease_power(id):
	while power_levels.size() <= id:
		power_levels.append(0)
	power_levels[id]-=1
	
	if powerables.size() <= id:
		return
	if power_levels[id] <= 0:
		for powerable in powerables[id]:
			powerable.on_depower()
		#powerables[id].all(func(a): a.on_depower())

func is_powered(id):
	if id > power_levels.size()-1:
		return false
	return power_levels[id] > 0
