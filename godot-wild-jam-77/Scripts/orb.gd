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
var can_combo = false

var id: String = str(uuid_util.v4())
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

func check_for_combo() -> void:
	if can_combo:
		check_next_orb(self)

enum CHAIN_STATUS {
	DEAD,
	VALID,
	COMBO,
}

class ComboChain:
	var orb_ids : Array[String] = []
	var type_counts : Dictionary = {}
	
	func add_orb(orb:Orb)-> void:
		orb_ids.append(str(orb.id))
		type_counts[orb.type] = type_counts.get(orb.type,0) + 1
		
	func remove_orb(orb:Orb)-> void:
		orb_ids.erase(orb.id)
		type_counts[orb.type] -= 1
		if type_counts[orb.type] <= 0:
			type_counts.erase(orb.type)

func check_next_orb(starting_orb: Orb) -> void:
	var visited = {}
	var chain = ComboChain.new()
	var remaining_orbs: Array[Orb] = [starting_orb]
	
	if is_debug:
		print("\n🔍 Starting combo check from orb: " + str(starting_orb.id))
	
	while not remaining_orbs.is_empty():
		var curr_orb = remaining_orbs.pop_front()
		
		if not curr_orb.can_combo:
			debug_print(chain, "Skipping disabled orb: " + str(curr_orb.id))
			continue
			
		if visited.has(curr_orb.id):
			debug_print(chain, "Skipping visited orb: " + str(curr_orb.id))
			continue
			
		visited[curr_orb.id] = true
		chain.add_orb(curr_orb)
		
		var valid_combo_result = is_still_valid_combo(chain.type_counts)
		var chain_status = valid_combo_result[0]
		var result = valid_combo_result[1]
		match chain_status:
			CHAIN_STATUS.DEAD:
				debug_print(chain, "❌ Dead chain found, removing orb: " + str(curr_orb.id))
				chain.remove_orb(curr_orb)
				continue
			CHAIN_STATUS.VALID:
				debug_print(chain, "✓ Valid chain, checking connected orbs")
				for next_orb in curr_orb.colliding_orbs:
					if not visited.has(next_orb.id):
						remaining_orbs.push_back(next_orb)
			CHAIN_STATUS.COMBO:
				debug_print(chain, "🎯 COMBO FOUND!")
				combo_made_with.emit(chain.orb_ids, result)
				return

func is_still_valid_combo(chain) -> Array: # [CHAIN_STATUS, OrbType]
	"""
	Validates if a chain of orbs can form a valid combination.
	
	A chain can be in three states:
	- COMBO: All required orbs are present in exact quantities
	- VALID: Has the right types and quantities but might need more orbs
	- DEAD: Has wrong types or too many orbs, can't form a valid combo
	"""
	var still_valid_combos = 0
	
	# Check each possible recipe (combination pattern)
	for index in range(allowed_combos.size()):
		var recipe = allowed_combos[index]
		var could_match = true  # Could this become a valid combo?
		var is_perfect_match = true  # Do we have exactly what we need?
		
		# First, check if all required recipe types exist in our chain
		for required_type in recipe:
			var required_count = recipe[required_type]
			var current_count = chain.get(required_type, 0)
			
			if current_count == 0:
				# Missing a required type entirely
				is_perfect_match = false
			elif current_count < required_count:
				# Don't have enough of this type yet
				is_perfect_match = false
			elif current_count > required_count:
				# Have too many of this type
				could_match = false
				is_perfect_match = false
		
		# Now check if chain has any extra types not in recipe
		for chain_type in chain:
			if not recipe.has(chain_type):
				# Found an orb type that isn't in our recipe
				could_match = false
				is_perfect_match = false
				break
		
		# If everything matches perfectly, we found a combo!
		if is_perfect_match:
			if is_debug:
				print("Perfect match found with recipe: ", recipe)
				print("Chain contents: ", chain)
			return [CHAIN_STATUS.COMBO, combo_results[index].new()]
			
		# If we could still complete this recipe, count it
		if could_match:
			still_valid_combos += 1
	
	# If we found any valid potential matches, the chain is still valid
	if still_valid_combos > 0:
		return [CHAIN_STATUS.VALID, null]
		
	# No valid combinations possible with these orbs
	return [CHAIN_STATUS.DEAD, null]

func _on_orb_body_exited(colliding_body: Node) -> void:
	if colliding_body is OrbBody:
		var index = colliding_orbs.find(colliding_body.get_orb())
		if index != -1:
			colliding_orbs.remove_at(index)

# Helper print function
func debug_print(chain: ComboChain, message: String = "") -> void:
	if not is_debug:
		return
		
	var type_summary = ""
	for orb_type in chain.type_counts.keys():
		# Convert the enum value to its name for readability
		var type_name = OrbType.ORB_TYPE.keys()[orb_type]
		type_summary += "\n    %s: %d" % [type_name, chain.type_counts[orb_type]]
	
	print("\n=== Chain Status ===")
	if message:
		print("Event: " + message)
	print("Chain Types:" + (type_summary if type_summary else "\n    Empty chain"))
	print("Chain IDs: " + str(chain.orb_ids))
	print("==================\n")
