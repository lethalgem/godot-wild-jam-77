class_name Orb extends Node2D

signal combo_made_with(ids: Array[String])

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
	for next_orb in colliding_orbs:
		# travel the chain
		check_next_orb([[id, next_orb.id]], [{next_orb.type: 0}], next_orb)

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
	"""
	Balls
	"""
	# Each new orb could have multiple collisions, so we need to check all of those and see if we continue
	print("Type Chains: ", type_chains)
	print("ID Chains: ", id_chains)
	
	for index in range(type_chains.size()):
		# Add our increment the current orb's type in our count
		var chain = type_chains[index]
		var current_type_count = chain.get_or_add(orb.type, 0)
		chain[orb.type] = current_type_count + 1
		
		# Does this orb have a combo in its chain that is valid
		# Doesn't have to be a complete combo but it needs to have
		# elements of it
		match is_still_valid_combo(chain):
			CHAIN_STATUS.DEAD:
				return
			CHAIN_STATUS.VALID:
				# Chain might form a combo, keep checking
				# Recursively check for more orbs
				id_chains[index].append(orb.id)
				for next_orb in orb.colliding_orbs:
					check_next_orb(id_chains, type_chains, next_orb)
			CHAIN_STATUS.COMBO:
				# Found a combo, emit a signal with the involved orbs, exit
				var combo_ids: Array[String]
				for uuid in id_chains[index]:
					combo_ids.append(str(uuid))
				combo_made_with.emit(combo_ids)
				return
	
func is_still_valid_combo(chain) -> CHAIN_STATUS:
	"""
	If the chain has any valid combo in the list of
	allowed combos we return VALID.

	If the chain meets all the values in the combo we
	return COMBO

	If the chain doesn't meet any of the allowed combos
	return DEAD. We shouldn't keep pursuing that chain at all.
	"""
	# How many possible valid combinations we could still make
	var still_valid_combos = 0
	
	# Loop through each combo that's allowed
	# E.g., if we need 3 water orbs for a combo, that would be [{Water, 3}]
	for allowed_combo in allowed_combos: # [{Water, 3}]
		var is_full_combo = true
		var is_chain_valid = true
		
		# Check each type of orb in the current chain
		for chained_orb_type in chain.keys(): # Water in [{Water, 1}]
			
			# How many of this type do we need for the combo?
			var value_required_for_combo = allowed_combo.get(chained_orb_type) # 3
			
			# If not allowed in our combo at all, the combo can't work, break
			if value_required_for_combo == null:
				is_full_combo = false
				is_chain_valid = false
				break; 
			
			# If we don't have enough of this type yet...
			elif value_required_for_combo > chain.get(chained_orb_type):
				is_full_combo = false
		
		if is_full_combo:
			return CHAIN_STATUS.COMBO
		
		if is_chain_valid:
			still_valid_combos += 1

	if still_valid_combos > 0:
		return CHAIN_STATUS.VALID
	else:
		return CHAIN_STATUS.DEAD

func _on_orb_body_exited(colliding_body: Node) -> void:
	if colliding_body is OrbBody:
		var index = colliding_orbs.find(colliding_body.get_orb())
		if index != -1:
			colliding_orbs.remove_at(index)
