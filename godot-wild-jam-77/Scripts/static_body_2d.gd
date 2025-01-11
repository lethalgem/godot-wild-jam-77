extends StaticBody2D

@onready var polygon_2d = $Polygon2D
@onready var bowl_collision_polygon_2d = $BowlCollisionPolygon2D
var total_weight = 0
var weights = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	bowl_collision_polygon_2d.polygon = polygon_2d.polygon
	bowl_collision_polygon_2d.position = polygon_2d.position
	bowl_collision_polygon_2d.scale = polygon_2d.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calcualte_weight_on_body_enter(body):
	total_weight += weights
	pass
	
