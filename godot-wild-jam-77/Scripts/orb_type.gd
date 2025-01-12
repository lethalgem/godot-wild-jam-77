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

class Fire extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.FIRE
		properties.color = Color.RED
		properties.weight = 5.0
		# Doesn't include its own orb
		properties.allowed_combos = [{ORB_TYPE.WATER: 2}]
		properties.combo_results = [GRASS]
		
class Water extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.WATER
		properties.color = Color.BLUE
		properties.allowed_combos = [{ORB_TYPE.WATER: 2, ORB_TYPE.FIRE: 1}] # TODO: Avoid having to put the inverse combo, currently we only look from the origin of the combo down, and don't consider combining branches
		properties.combo_results = [GRASS]

class GRASS extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.GRASS
		properties.weight = 40
		properties.color = Color.GREEN
