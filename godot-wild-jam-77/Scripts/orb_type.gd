## The layer on top that serves to tell the orb what type it is
## We should not be using Orb much, rather use this controller

class_name OrbType

enum ORB_TYPE {
	FIRE,
	WATER,
	GRASS,
	GOLD,
	DIAMOND,
}

class OrbProperties:
	var type: ORB_TYPE
	# Defaults
	var radius: float = 40.0
	var weight: float = 10.0
	var color: Color = Color.RED
	var allowed_combos ## Array[Array[OrbType]], default is none
	var combo_results ## Array[OrbType] - matches index of allowed_combo
	var label_text: String = "T"

class Fire extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.FIRE
		properties.color = Color.RED
		properties.allowed_combos = [{ORB_TYPE.WATER: 2,ORB_TYPE.FIRE:1}, {ORB_TYPE.GRASS: 1, ORB_TYPE.FIRE: 2}, {ORB_TYPE.WATER: 1,ORB_TYPE.FIRE:1, ORB_TYPE.GRASS:1}]
		properties.combo_results = [GRASS, GOLD, DIAMOND]
		properties.label_text = "F"
		
class Water extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.WATER
		properties.color = Color.AQUA
		properties.allowed_combos = [{ORB_TYPE.WATER: 2, ORB_TYPE.FIRE: 1}, {ORB_TYPE.WATER: 1,ORB_TYPE.FIRE:1, ORB_TYPE.GRASS:1}]
		properties.combo_results = [GRASS, DIAMOND]
		properties.label_text = "W"

class GRASS extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.GRASS
		properties.weight = 40
		properties.color = Color.GREEN
		properties.radius = 60.0
		properties.allowed_combos = [{ORB_TYPE.GRASS: 1, ORB_TYPE.FIRE: 2}, {ORB_TYPE.WATER: 1,ORB_TYPE.FIRE:1, ORB_TYPE.GRASS:1}]
		properties.combo_results = [GOLD, DIAMOND]
		properties.label_text = "G"

class GOLD extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.GOLD
		properties.weight = 100
		properties.color = Color.GOLD
		properties.radius = 70.0
		properties.allowed_combos = [{ORB_TYPE.WATER: 1,ORB_TYPE.FIRE:1, ORB_TYPE.GRASS:1}]
		properties.combo_results = [DIAMOND]
		properties.label_text = "A"

class DIAMOND extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.DIAMOND
		properties.weight = 300
		properties.color = Color.LIGHT_BLUE
		properties.radius = 80.0
		properties.label_text = "D"
