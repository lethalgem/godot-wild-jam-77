## The layer on top that serves to tell the orb what type it is
## We should not be using Orb much, rather use this controller

class_name OrbType

enum ORB_TYPE {
	FIRE,
	WATER,
	EARTH,
	GOLD,
	DIAMOND,
	LIGHTNING,
	THUNDER,
	STEEL,
	PLASMA,
	OBSIDIAN,
	VOID
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
			#combo_text += " -> %s" % 
			
			formatted_combos.append(combo_text)
		
		return formatted_combos

class Fire extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.FIRE
		properties.color = Color.RED
		properties.label_text = "F"
		properties.allowed_combos = [
		#EARTH
		{
			ORB_TYPE.FIRE: 1,
			ORB_TYPE.WATER:2
			},
		{
			ORB_TYPE.FIRE: 2,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:2
			},
			{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:2
			},
		#GOLD
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.FIRE: 2
			},
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.FIRE: 3
			},
		{
			ORB_TYPE.GOLD:1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.DIAMOND:1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:2
			},
		#PLASMA
		{
			ORB_TYPE.LIGHTNING: 1,
			ORB_TYPE.FIRE: 2,
			},
		#VOID
		{
			ORB_TYPE.PLASMA: 1,
			ORB_TYPE.FIRE: 2,
			ORB_TYPE.WATER: 1
			},
		{
			ORB_TYPE.OBSIDIAN: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:2
			},
		{
			ORB_TYPE.STEEL: 1,
			ORB_TYPE.FIRE: 1,
			ORB_TYPE.WATER: 2
			}
		]
		properties.combo_results = [EARTH,EARTH,EARTH,EARTH,EARTH,EARTH,GOLD,GOLD,LIGHTNING,LIGHTNING,PLASMA,VOID,VOID,VOID]

	
class Water extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.WATER
		properties.color = Color.AQUA
		properties.label_text = "W"
		properties.allowed_combos = [
		#EARTH
		{
			ORB_TYPE.FIRE: 1,
			ORB_TYPE.WATER:2
			},
		{
			ORB_TYPE.FIRE: 2,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:2
			},
			{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:2
			},
		#DIAMOND
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.WATER: 2
			},
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.WATER: 3
			},
		#LIGHTNING
		{
			ORB_TYPE.GOLD:1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.DIAMOND:1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:2
			},
		#STEEL
		{
			ORB_TYPE.THUNDER: 1,
			ORB_TYPE.WATER: 2
			},
		#VOID
		{
			ORB_TYPE.PLASMA: 1,
			ORB_TYPE.FIRE: 2,
			ORB_TYPE.WATER: 1
			},
		{
			ORB_TYPE.OBSIDIAN: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:2
			},
		{
			ORB_TYPE.STEEL: 1,
			ORB_TYPE.FIRE: 1,
			ORB_TYPE.WATER: 2
			}
		]
		properties.combo_results = [EARTH,EARTH,EARTH,EARTH,EARTH,EARTH,DIAMOND,DIAMOND,LIGHTNING,LIGHTNING,STEEL,VOID,VOID,VOID]

	
class EARTH extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.EARTH
		properties.weight = 40
		properties.color = Color.GREEN
		properties.radius = 60.0
		properties.label_text = "E"
		properties.allowed_combos = [
		#GOLD
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.FIRE: 2
			},
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.FIRE: 3
			},
		#DIAMOND
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.WATER: 2
			},
		{
			ORB_TYPE.EARTH: 1,
			ORB_TYPE.WATER: 3
			},
		#LIGHTNING
		{
			ORB_TYPE.EARTH: 3
			}
		]
		properties.combo_results = [GOLD,GOLD,DIAMOND,DIAMOND,LIGHTNING]

	
class GOLD extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.GOLD
		properties.weight = 300
		properties.color = Color.GOLD
		properties.radius = 70.0
		properties.label_text = "Au"
		properties.allowed_combos = [
			#LIGHTNING
			{
				ORB_TYPE.GOLD:2
				},
			{
				ORB_TYPE.GOLD:1,
				ORB_TYPE.FIRE:2,
				ORB_TYPE.WATER:1
				}
			]
		properties.combo_results = [LIGHTNING,LIGHTNING]

	
class DIAMOND extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.DIAMOND
		properties.weight = 300
		properties.color = Color.LIGHT_BLUE
		properties.radius = 80.0
		properties.label_text = "D"
		properties.allowed_combos = [
			#LIGHTNING
			{
				ORB_TYPE.DIAMOND:2
				},
			{
				ORB_TYPE.DIAMOND:1,
				ORB_TYPE.FIRE:1,
				ORB_TYPE.WATER:2
				}
			]
		properties.combo_results = [THUNDER,THUNDER]

	
class LIGHTNING extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.LIGHTNING
		properties.weight = 600
		properties.color = Color.KHAKI
		properties.radius = 120.0
		properties.label_text = "L"
		properties.allowed_combos = [
		#PLASMA
		{
			ORB_TYPE.LIGHTNING: 2
			},
		{
			ORB_TYPE.LIGHTNING: 1,
			ORB_TYPE.FIRE: 2,
			},
		#OBSIDIAN
		{
			ORB_TYPE.LIGHTNING: 1,
			ORB_TYPE.THUNDER:1
			},
		]
		properties.combo_results = [PLASMA,PLASMA,OBSIDIAN]

		
class THUNDER extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.THUNDER
		properties.weight = 600
		properties.color = Color.DARK_MAGENTA
		properties.radius = 120.0
		properties.label_text = "Th"
		properties.allowed_combos = [
		#STEEL
		{
			ORB_TYPE.THUNDER: 2
			},
		{
			ORB_TYPE.THUNDER: 1,
			ORB_TYPE.WATER: 2
			},
		#OBSIDIAN
		{
			ORB_TYPE.LIGHTNING: 1,
			ORB_TYPE.THUNDER:1
			}
		]
		properties.combo_results = [STEEL,STEEL,OBSIDIAN]
		
class STEEL extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.STEEL
		properties.weight = 1000
		properties.color = Color.DARK_CYAN
		properties.radius = 150.0
		properties.label_text = "FE"
		properties.allowed_combos = [
		#VOID
		{
			ORB_TYPE.STEEL: 2
			},
		{
			ORB_TYPE.STEEL: 1,
			ORB_TYPE.FIRE: 1,
			ORB_TYPE.WATER: 2
			}
		]
		properties.combo_results = [VOID,VOID]

class PLASMA extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.PLASMA
		properties.weight = 1000
		properties.color = Color.MEDIUM_SPRING_GREEN
		properties.radius = 150.0
		properties.label_text = "PL"
		properties.allowed_combos = [
		#VOID
		{
			ORB_TYPE.PLASMA: 2
			},
		{
			ORB_TYPE.PLASMA: 1,
			ORB_TYPE.FIRE: 2,
			ORB_TYPE.WATER: 1
			}
		]
		properties.combo_results = [VOID,VOID]
		
class OBSIDIAN extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.OBSIDIAN
		properties.weight = 2000
		properties.color = Color.INDIGO
		properties.radius = 170.0
		properties.label_text = "OB"
		properties.allowed_combos = [
		#VOID
		{
			ORB_TYPE.OBSIDIAN: 2
			},
		{
			ORB_TYPE.OBSIDIAN: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:2
			},
		]
		properties.combo_results = [VOID,VOID]
	
class VOID extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.type = ORB_TYPE.VOID
		properties.weight = 5000
		properties.color = Color.BLACK
		properties.radius = 200.0
		properties.label_text = "V"
		properties.allowed_combos = [
		#EARTH
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:1
			},
		{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:1,
			ORB_TYPE.WATER:2
			},
			{
			ORB_TYPE.VOID: 1,
			ORB_TYPE.FIRE:2,
			ORB_TYPE.WATER:2
			}
		]
		properties.combo_results = [EARTH,EARTH,EARTH,EARTH]
