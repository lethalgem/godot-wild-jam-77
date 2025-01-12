class_name Scale extends StaticBody2D

signal goal_weight_achieved
signal updated_weight(weight: float)

@onready var polygon_2d = $Polygon2D
@onready var bowl_collision_polygon_2d = $BowlCollisionPolygon2D
@onready var area_2d = $InsideArea2D
@onready var path_2d = $Path2D

@export var goal_weight: float = 100
var type_count = {}
var type_weights = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var points = path_2d.curve.get_baked_points()
	
	polygon_2d.polygon = points
	polygon_2d.position = path_2d.position
	bowl_collision_polygon_2d.polygon = polygon_2d.polygon
	bowl_collision_polygon_2d.position = polygon_2d.position
	
func update_goal_weight(weight: float):
	goal_weight = weight

func calculate_weight():
	var total_weight: int = 0
	for type in type_count.keys():
		total_weight += type_count[type] * type_weights[type] * Globals.weight_score_multiplier
	updated_weight.emit(total_weight)
	if total_weight >= goal_weight:
		goal_weight_achieved.emit()

func _on_inside_area_2d_body_entered(body: Node2D):
	if body is OrbBody:
		var orb = body.get_orb()
		if type_count.has(orb.type):
			var count = type_count[orb.type]
			count += 1
			type_count[orb.type] = count
			calculate_weight()
		else:
			type_count[orb.type] = 1
			type_weights[orb.type] = orb.weight
			calculate_weight()

func _on_inside_area_2d_body_exited(body: Node2D):
	if body is OrbBody:
		var orb = body.get_orb()
		if type_count.has(orb.type):
			var count = type_count[orb.type]
			count -= 1
			type_count[orb.type] = count
			calculate_weight()
