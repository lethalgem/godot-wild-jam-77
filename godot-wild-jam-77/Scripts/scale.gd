class_name Scale extends StaticBody2D

@onready var polygon_2d = $Polygon2D
@onready var bowl_collision_polygon_2d = $BowlCollisionPolygon2D
@onready var area_2d = $InsideArea2D
@onready var weight_label = $WeightLabel

var goal_weight: float = 100 * Globals.weight_score_multipliers
var type_count = {}
var type_weights = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	bowl_collision_polygon_2d.polygon = polygon_2d.polygon
	bowl_collision_polygon_2d.position = polygon_2d.position
	bowl_collision_polygon_2d.scale = polygon_2d.scale

func calculate_weight():
	var total_weight: int = 0
	for type in type_count.keys():
		total_weight += type_count[type] * type_weights[type] * Globals.weight_score_multiplier
	weight_label.text = str(total_weight)
	if total_weight >= goal_weight:
		print("Winner")

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
