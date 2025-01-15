## The layer on top that serves to tell the orb what type it is
## We should not be using Orb much, rather use this controller

class_name OrbType

enum ORB_TYPE {
	FIRE,
	WATER,
	GRASS,
}

class OrbProperties:
	var type: ORB_TYPE
	# Defaults
	var radius: float = 50.0
	var weight: float = 10.0
	var color: Color = Color.RED
	var allowed_combos ## Array[Array[OrbType]], default is none
	var combo_results ## Array[OrbType] - matches index of allowed_combo
	
	func format_combos() -> Array:
	# If there are no combos, return an empty array
		if allowed_combos == null or allowed_combos.is_empty():
			return []
			
		var formatted_combos = []
		
		# Loop through each combo and its corresponding result
		for i in range(allowed_combos.size()):
			var combo = allowed_combos[i]
			var result = combo_results[i]
			var combo_text = ""
			
			# Build a list of required orbs (e.g., "WATER x2, FIRE x1")
			var requirements = []
			for orb_type in combo.keys():
				# Convert enum value to readable name and add quantity
				var type_name = OrbType.ORB_TYPE.keys()[orb_type]
				var count = combo[orb_type]
				requirements.append("%s x%d" % [type_name, count])
				
			# Join the requirements with commas and add the result
			combo_text = ", ".join(requirements)
			combo_text += " -> %s" % OrbType.ORB_TYPE.keys()[2]
			
			formatted_combos.append(combo_text)
		
		return formatted_combos
	

class Fire extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.FIRE
		properties.color = Color.RED
		properties.weight = 5.0
		properties.allowed_combos = [{ORB_TYPE.WATER: 2,ORB_TYPE.FIRE:1}]
		properties.combo_results = [GRASS]
		
class Water extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.WATER
		properties.color = Color.BLUE
		properties.allowed_combos = [{ORB_TYPE.WATER: 2, ORB_TYPE.FIRE: 1}]
		properties.combo_results = [GRASS]

class GRASS extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.GRASS
		properties.weight = 40
		properties.color = Color.GREEN
		properties.allowed_combos = [{ORB_TYPE.WATER: 2, ORB_TYPE.FIRE: 1}]
		properties.combo_results = [GRASS]
