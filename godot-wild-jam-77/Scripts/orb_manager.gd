class_name OrbManager extends Node2D

@export var is_debug_mode: bool = false
@export var debug_marker: Marker2D

@export var spawn_limit: int = 50
@export var orb_spawner: OrbSpawner

var orb_type_queue: Array[OrbType] = [OrbType.Water.new(), OrbType.Water.new(), OrbType.Fire.new()]
var total_spawned: int = 0
var spawned_orbs = {} # {id, orb} for easy lookup
var in_progress_combos = {} # {id, true} to prevent duplicating combos with easy comparison

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

# TODO: Animation showing the orbs merge -- JUICE it up, screen shake, particle effects, big numbers!
func handle_combo(ids: Array[String], result: OrbType):
	print("test")
	
	for id in ids:
		if in_progress_combos.has(id):
			return
		else:
			in_progress_combos[id] = true
	
	print(in_progress_combos)
	var merge_position: Vector2
	for index in range(ids.size()):
		var combo_orb: Orb = spawned_orbs[ids[index]]
		
		if index == (ids.size() / 2):
			merge_position = combo_orb.body.global_position
			if is_debug_mode and debug_marker != null:
				debug_marker.visible = true
				debug_marker.global_position = merge_position
		
		combo_orb.queue_free()
		spawned_orbs.erase(combo_orb.id)
	
	# Cleanup the in_progress_combos id list after arbitrary period (combo should be done by then)
	get_tree().create_timer(1).timeout.connect((
		func(ids):
			for id in ids:
				in_progress_combos.erase(id)).bind(ids))
		
	orb_spawner.spawn_orb_at(merge_position, result)
