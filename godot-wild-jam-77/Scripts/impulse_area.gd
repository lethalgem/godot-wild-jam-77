class_name ImpulseArea extends Area2D

signal impulse_finished

@export var orb: Orb

var should_impulse: bool = false
var impulse_speed: float = 100.0
var overlapping_orb_bodies: Array[OrbBody] = []
var impulse_delay: float = 0.2 ##seconds

func apply_impulse(speed: float):
	should_impulse = true
	impulse_speed = speed
	get_tree().create_timer(impulse_delay).timeout.connect(impulse_neighbors)

func impulse_neighbors():
	for body in overlapping_orb_bodies:
		if body != null:
			var direction = global_position.direction_to(body.position)
			body.apply_impulse(direction * impulse_speed)
	should_impulse = false
	impulse_finished.emit()

func _on_body_entered(body: Node2D) -> void:
	if body is OrbBody:
		overlapping_orb_bodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body is OrbBody:
		overlapping_orb_bodies.erase(body)
