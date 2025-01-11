class_name Orb extends Node2D

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
	for starting_orb in colliding_orbs:
		# travel the chain
		check_next_orb([{starting_orb.type: 0}], starting_orb)

enum CHAIN_STATUS {
	DEAD,
	VALID,
	COMBO,
}

func check_next_orb(chains, next_orb: Orb) -> void:
	# Each new orb could have multiple collisions, so we need to check all of those and see if we continue
	for chain in chains:
		#print("checking chain:")
		var current_type_count = chain.get_or_add(next_orb.type, 0)
		chain[next_orb.type] = current_type_count + 1 # not sure if this is by reference or not and needs to be updated
		match is_still_valid_combo(chain):
			CHAIN_STATUS.DEAD:
				#print("Dead")
				return
			CHAIN_STATUS.VALID:
				#print("Valid, checking the next")
				var next_orb_colliding_orbs: Array[Orb] = next_orb.colliding_orbs
				for next_orb_colliding_orb in next_orb_colliding_orbs:
					#print("next")
					check_next_orb(chains, next_orb)
			CHAIN_STATUS.COMBO:
				#print("Combo!")
				# TODO: Tell the manager the ids of the orbs and make them go bye bye!
				return
	
func is_still_valid_combo(chain) -> CHAIN_STATUS:
	var still_valid_combos = 0
	for allowed_combo in allowed_combos: # [{Water, 3}]
		var is_full_combo = true
		var is_chain_valid = true
		#print("allowed_combo: " + str(allowed_combo))
		#print("chain: " + str(chain))
		for type in chain.keys(): # Water in [{Water, 1}]
			var value_required_for_combo = allowed_combo.get(type) # 3
			if value_required_for_combo == null:
				is_full_combo = false
				is_chain_valid = false
				break; # quit searching for this particular combo
			elif value_required_for_combo > chain.get(type):
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
