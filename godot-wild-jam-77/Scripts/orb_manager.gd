class_name OrbManager extends Node2D

@export var spawn_limit: int = 50
@export var orb_spawner: OrbSpawner

var orb_type_queue: Array[OrbType] = [OrbType.Fire.new()]
var total_spawned: int = 0
var spawned_orbs = {} # {id, orb} for easy lookup 

func add_new_orb_to_queue() -> void:
	var possible_types = [OrbType.Fire, OrbType.Water]
	var picked_type = possible_types.pick_random()
	orb_type_queue.push_front(picked_type.new())

func get_next_orb_type() -> OrbType:
	if total_spawned >= spawn_limit:
		print("Game Over!")
	else:
		total_spawned += 1
		add_new_orb_to_queue()
	
	return orb_type_queue.pop_back()

func add_spawned(orb: Orb) -> void:
	spawned_orbs[orb.id] = orb
	orb.combo_made_with.connect(handle_combo)

func handle_combo(ids: Array[String]):
	print("got combo")
	var combo_orbs: Array[Orb]
	for id in ids:
		combo_orbs.append(spawned_orbs[id])
	print(combo_orbs)
