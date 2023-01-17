extends RigidBody2D

const DIRECTION_RANGE = PI / 4
const MIN_SPEED = 200
const MAX_SPEED = 600

var hp: int = 10

func _init() -> void:
	var outline = create_outline()
	set_collision_shape(outline)
	set_drawn_shape(outline)

func _ready() -> void:
	var start_impulse: Vector2 = \
		(Vector2.ZERO - get_global_position()) \
			.normalized() \
			.rotated(DIRECTION_RANGE * 2 * randf() - DIRECTION_RANGE) \
			* (MIN_SPEED + (MAX_SPEED - MIN_SPEED) * randf())
	apply_central_impulse(start_impulse)

# Generate a random shape for a new asteroid
func create_outline() -> PoolVector2Array:
	# The number of points in the asteroid's outline, 9-24
	# Some asteroids will have lots of detail, some will be chunky
	var count = 9 + randi() % 15
	var step = PI * 2 / count
	
	# Minimum radius for each point in the asteroid, 16-48
	# Some asteroids will be big, some not so big.
	var radius = 16 + randi() % 32
	
	# Maximum amount of random noise to be added to a point's radius, 8-32
	# Some asteroids will be smooth, some will be spiky.
	var noise = 8 + randi() % 24
	
	var points = []
	# Avoid using append when we know the final size of the array.
	points.resize(count)
	
	for i in count:
		# Vary the angle between points by one step, for extra irregularity.
		var angle = step * i + randf() * step
		var dist = radius + noise * randf()
		points[i] = Vector2(sin(angle) * dist, cos(angle) * dist)
		
	return PoolVector2Array(points)

# Set the hitbox for a new asteroid
func set_collision_shape(outline: PoolVector2Array) -> void:
	# ConcavePolygonShape2D is "not advised to use for RigidBody2D nodes".
	# We therefore perform a convex decomposition using triangulate_polygon.
	var owner: int = create_shape_owner(self)
	var triangles = Geometry.triangulate_polygon(outline)
	for i in range(0, len(triangles), 3):
		var shape = ConvexPolygonShape2D.new()
		shape.set_points([
			outline[triangles[i]],
			outline[triangles[i + 1]],
			outline[triangles[i + 2]]
		])
		shape_owner_add_shape(owner, shape)

# Set the visible shape of a new asteroid
func set_drawn_shape(outline: PoolVector2Array) -> void:
	var polygon = Polygon2D.new()
	polygon.set_polygon(outline)
	polygon.set_color(Color(0.372549, 0.341176, 0.309804, 1))
	add_child(polygon)


func take_damage(value: int = 1) -> void:
	hp -= value

	if hp <= 0:
		EventBus.emit_signal("asteroid_destroyed", 10)
		queue_free()
