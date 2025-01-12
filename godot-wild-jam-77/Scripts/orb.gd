class_name Orb extends Node2D

signal combo_made_with(ids: Array[String], result: OrbType)

@export var weight_factor: float = 1.0
@export var body: OrbBody
@export var background: OrbBackground
@export var collision_shape: CollisionShape2D

## Set to see debug info
@export var is_debug: bool = false
@onready var debug_weight_label = %DEBUG_WEIGHT_LABEL

const uuid_util = preload("res://addons/uuid/uuid.gd")

# Properties to be set
var color
var radius
var weight
var allowed_combos = [{}] ## Array[{OrbType.ORB_TYPE:Count}], default is none
var combo_results = [] ## Array[OrbType.ORB_TYPE] - matches index of allowed_combo, default is none
var type: OrbType.ORB_TYPE

var id = uuid_util.v4()
var colliding_orbs: Array[Orb]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.background_color = color
	background.radius = radius
	collision_shape.shape.radius = radius
	body.mass = weight * weight_factor
	
	if is_debug:
		debug_weight_label.text = str(weight)


func _on_orb_body_entered(colliding_body: Node) -> void:
	if colliding_body is OrbBody:
		colliding_orbs.append(colliding_body.get_orb())
		if allowed_combos != null:
			check_for_combo()

# jank solution to combos is to detect a collision, then travel down the path
# of all collisions to see if achieve a combo is achieved
# if it is, tell the manager via signal that we made one
# couple of issues though, 
# - we will have multiple report (ex, 5 are required for a combo, and all 5 
# travel their collision chain, so all 5 will report the same combo
# - there MUST be a more performant way to do this. Checking every collision
# as it happens, is going to be costly. Especially in a browser window
func check_for_combo() -> void:
	# check every body we're colliding with because that is the start of a chain
	for starting_orb in colliding_orbs:
		# travel the chain
		check_next_orb([[id, starting_orb.id]], [{starting_orb.type: 0}], starting_orb)

enum CHAIN_STATUS {
	DEAD,
	VALID,
	COMBO,
}

# TODO: We currently combo when only one of the requirements in the combo dictionary is met, it needs to be all of them
func check_next_orb(
				id_chains, # Array[Array[String]]
				type_chains, # Array[{type: count}
				orb: Orb) -> void:
	# Each new orb could have multiple collisions, so we need to check all of those and see if we continue
	for index in range(type_chains.size()):
		var chain = type_chains[index]
		var current_type_count = chain.get_or_add(orb.type, 0)
		chain[orb.type] = current_type_count + 1
		var is_still_valid_combo = is_still_valid_combo(chain)
		match is_still_valid_combo[0]:
			CHAIN_STATUS.DEAD:
				return
			CHAIN_STATUS.VALID:
				id_chains[index].append(orb.id)
				for next_orb in orb.colliding_orbs:
					check_next_orb(id_chains, type_chains, next_orb)
			CHAIN_STATUS.COMBO:
				var combo_ids: Array[String]
				for uuid in id_chains[index]:
					combo_ids.append(str(uuid))
				combo_made_with.emit(combo_ids, is_still_valid_combo[1].new())
				return
	
func is_still_valid_combo(chain):
	var still_valid_combos = 0
	for index in range(allowed_combos.size()): # [{Water, 3}]
		var allowed_combo = allowed_combos[index]
		var is_full_combo = true
		var is_chain_valid = true
		for chained_orb_type in chain.keys(): # Water in [{Water, 1}]
			var value_required_for_combo = allowed_combo.get(chained_orb_type) # 3
			if value_required_for_combo == null:
				is_full_combo = false
				is_chain_valid = false
				break; # quit searching for this particular combo
			elif value_required_for_combo > chain.get(chained_orb_type):
				is_full_combo = false
		
		if is_full_combo:
			return [CHAIN_STATUS.COMBO, combo_results[index]]
		
		if is_chain_valid:
			still_valid_combos += 1

	if still_valid_combos > 0:
		return [CHAIN_STATUS.VALID, null]
	else:
		return [CHAIN_STATUS.DEAD, null]

func _on_orb_body_exited(colliding_body: Node) -> void:
	if colliding_body is OrbBody:
		var index = colliding_orbs.find(colliding_body.get_orb())
		if index != -1:
			colliding_orbs.remove_at(index)
