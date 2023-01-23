class_name Asteroid
extends RigidBody2D

const DIRECTION_RANGE = PI / 8
const MIN_SPEED = 200
const MAX_SPEED = 600

# Constants for shape generation

const MIN_SEGMENTS = 9
const SEGMENT_RANGE = 15

const MIN_RADIUS = 16
const RADIUS_RANGE = 32

const MIN_NOISE = 8
const NOISE_RANGE = 24

# Constants for mass calculation
const MASS_LIMIT = 50.0
# Maximum possible size if we happen to generate a perfect circle
const SIZE_LIMIT = PI * pow(MIN_RADIUS + RADIUS_RANGE + MIN_NOISE + NOISE_RANGE, 2)

var hp: int = 10

func _init() -> void:
	init_material()
	
	var outline = create_outline()
	set_collision_shape(outline)
	set_drawn_shape(outline)
	compute_mass(outline)

func _ready() -> void:
	add_to_group("enemy")
	var start_impulse: Vector2 = \
		(Vector2.ZERO - get_global_position()) \
			.normalized() \
			.rotated(DIRECTION_RANGE * 2 * randf() - DIRECTION_RANGE) \
			* (MIN_SPEED + (MAX_SPEED - MIN_SPEED) * randf())
	apply_central_impulse(start_impulse)


func init_material() -> void:
	var material = PhysicsMaterial.new()
	material.set_bounce(0.5)
	set_physics_material_override(material)
	set_linear_damp(0)
	set_angular_damp(0)


# Generate a random shape for a new asteroid
func create_outline() -> PoolVector2Array:
	# The number of points in the asteroid's outline, 9-24
	# Some asteroids will have lots of detail, some will be chunky
	var count = MIN_SEGMENTS + randi() % SEGMENT_RANGE
	var step = PI * 2 / count
	
	# Minimum radius for each point in the asteroid, 16-48
	# Some asteroids will be big, some not so big.
	var radius = MIN_RADIUS + randi() % RADIUS_RANGE
	
	# Maximum amount of random noise to be added to a point's radius, 8-32
	# Some asteroids will be smooth, some will be spiky.
	var noise = MIN_NOISE + randi() % NOISE_RANGE
	
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

func compute_mass(outline: PoolVector2Array) -> void:
	var area: float = 0
	var n = len(outline)
	for i in n:
		area += outline[i].x * outline[(i + 1) % n].y
		area -= outline[i].y * outline[(i + 1) % n].x
	area = abs(area) / 2
	
	print(area, "  ", SIZE_LIMIT, " ", MASS_LIMIT * area / SIZE_LIMIT)
	set_mass(MASS_LIMIT * (area / SIZE_LIMIT))


func take_damage(value: int = 1) -> void:
	hp -= value

	if hp <= 0:
		EventBus.emit_signal("asteroid_destroyed", 10)
		queue_free()
