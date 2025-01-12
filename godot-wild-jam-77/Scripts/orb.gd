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
		check_next_orb(next_orb)

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
		for i in orb_ids.size():
			if orb_ids[i] == orb.id:
				orb_ids.remove_at(i)
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
		
		if visited.has(curr_orb.id):
			debug_print(chain, "Skipping visited orb: " + str(curr_orb.id))
			continue
			
		visited[curr_orb.id] = true
		chain.add_orb(curr_orb)
		
		match is_still_valid_combo(chain.type_counts):
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
				combo_made_with.emit(chain.orb_ids)
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
