class_name Scale extends StaticBody2D

@onready var polygon_2d = $Polygon2D
@onready var bowl_collision_polygon_2d = $BowlCollisionPolygon2D
@onready var area_2d = $InsideArea2D
var total_weight : float = 0
var goal_weight : float = 100
var type_count = {}
var type_weights = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	bowl_collision_polygon_2d.polygon = polygon_2d.polygon
	bowl_collision_polygon_2d.position = polygon_2d.position
	bowl_collision_polygon_2d.scale = polygon_2d.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

func calculate_weight(type_count):
	for type in type_count.keys():
		total_weight = type_count[type] * type_weights[type]
		print(total_weight)
		if total_weight >= goal_weight:
			print("Winner")

func _on_inside_area_2d_body_entered(body: Node2D):
	if body is OrbBody:
		var orb = body.get_orb()
		if type_count.has(orb.type):
			var count = type_count[orb.type]
			count += 1
			type_count[orb.type] = count
			calculate_weight(type_count)
		else:
			type_count[orb.type] = 1
			type_weights[orb.type] = orb.weight
			calculate_weight(type_count)

func _on_inside_area_2d_body_exited(body: Node2D):
	if body is OrbBody:
		var orb = body.get_orb()
		if type_count.has(orb.type):
			var count = type_count[orb.type]
			count -= 1
			type_count[orb.type] = count
			calculate_weight(type_count)
