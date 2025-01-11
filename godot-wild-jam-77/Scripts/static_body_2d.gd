class_name Scale extends StaticBody2D

@onready var polygon_2d = $Polygon2D
@onready var bowl_collision_polygon_2d = $BowlCollisionPolygon2D
@onready var area_2d = $InsideArea2D
var total_weight : float = 0
var goal_weight : float = 25
var weights = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	bowl_collision_polygon_2d.polygon = polygon_2d.polygon
	bowl_collision_polygon_2d.position = polygon_2d.position
	bowl_collision_polygon_2d.scale = polygon_2d.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

func calculate_weight(weights):
	for i in weights:
		total_weight += i
	if total_weight == goal_weight:
		print("Winner")

func _on_inside_area_2d_body_entered(body: Node2D):
	if body is OrbBody:
		var orb = body.get_orb()
		if weights.has(orb.type):
			var count = weights[orb.type]
			count += 1
			weights[orb.type] = count
			print(weights)
		else:
			weights[orb.type] = 1
			print(weights)
			
func _on_inside_area_2d_body_exited(body: Node2D):
	if body is OrbBody:
		var orb = body.get_orb()
		if weights.has(orb.type):
			var count = weights[orb.type]
			count -= 1
			weights[orb.type] = count
			print(weights)
