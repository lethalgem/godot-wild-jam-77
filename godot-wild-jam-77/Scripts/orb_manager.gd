class_name OrbManager extends Node2D

@export var is_debug_mode: bool = false
@export var debug_marker: Marker2D

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
	spawned_orbs[str(orb.id)] = orb
	orb.combo_made_with.connect(handle_combo)

# TODO: Animation showing the orbs merge
func handle_combo(ids: Array[String], result: OrbType):
	var merge_position: Vector2
	for index in range(ids.size()):
		var combo_orb: Orb = spawned_orbs[ids[index]]
		
		if index == (ids.size() / 2):
			merge_position = combo_orb.body.global_position
			if is_debug_mode and debug_marker != null:
				debug_marker.visible = true
				debug_marker.global_position = merge_position
		
		combo_orb.queue_free()
		spawned_orbs.erase([ids[index]])
		
	orb_spawner.spawn_orb_at(merge_position, result)
