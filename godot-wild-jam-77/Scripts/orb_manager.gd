class_name OrbManager extends Node2D

@export var spawn_limit: int = 50
@export var orb_spawner: OrbSpawner

var spawn_queue: Array[OrbType] = [OrbType.Fire.new()]
var total_spawned: int = 0

func add_new_orb_to_queue() -> void:
	var possible_types = [OrbType.Fire, OrbType.Water]
	var picked_type = possible_types.pick_random()
	spawn_queue.push_front(picked_type.new())

func get_next_orb_type() -> OrbType:
	if total_spawned >= spawn_limit:
		print("Game Over!")
	else:
		total_spawned += 1
		add_new_orb_to_queue()
	
	return spawn_queue.pop_back()