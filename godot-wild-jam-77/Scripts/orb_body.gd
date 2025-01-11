class_name OrbBody extends RigidBody2D

@export var orb: Orb

func _ready():
	contact_monitor = true
	max_contacts_reported = 10

func get_orb() -> Orb:
	return orb
