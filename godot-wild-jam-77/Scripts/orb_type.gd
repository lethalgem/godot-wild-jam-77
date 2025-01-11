## The layer on top that serves to tell the orb what type it is
## We should not be using Orb much, rather use this controller

class_name OrbType

class OrbProperties:
	# Defaults
	var radius: float = 10.0
	var weight: float = 10.0
	var color: Color = Color.RED

class Fire extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.color = Color.RED
		
class Water extends OrbType:
	var properties = OrbProperties.new()
	
	func _init() -> void:
		properties.color = Color.BLUE
