extends Node

signal deregistered_active

const max_active = 3
var active_enemies = []

func try_register_active(enemy):
	if active_enemies.has(enemy):
		return true
	if active_enemies.size() >= max_active:
		return false
	active_enemies.append(enemy)
	return true

func deregister_active(enemy):
	active_enemies.erase(enemy)
	deregistered_active.emit()

func is_active(enemy):
	return active_enemies.has(enemy)

func reset():
	active_enemies.clear()
