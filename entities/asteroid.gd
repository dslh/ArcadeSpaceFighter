extends RigidBody2D


var hp: int = 10

func create_outline() -> PoolVector2Array:
	return PoolVector2Array([
		Vector2(16, -64),
		Vector2(48, -48),
		Vector2(40, -24),
		Vector2(48, -16),
		Vector2(56, 0),
		Vector2(56, 16),
		Vector2(64, 32),
		Vector2(56, 56),
		Vector2(32, 48),
		Vector2(16, 64),
		Vector2(-24, 56),
		Vector2(-56, 64),
		Vector2(-64, 40),
		Vector2(-48, 8),
		Vector2(-64, -24),
		Vector2(-56, -56),
		Vector2(-24, -48),
		Vector2(0, -56)
	])

func set_collision_shape(outline: PoolVector2Array) -> void:
	var owner: int = create_shape_owner(self)
	var shape = ConcavePolygonShape2D.new()
	shape.set_segments(outline)
	shape_owner_add_shape(owner, shape)

func _ready() -> void:
	var start_impulse: Vector2 = (Vector2.ZERO - get_global_position())*randf()
	apply_central_impulse(start_impulse)

	var outline = create_outline()
	set_collision_shape(outline)
	set_drawn_shape(outline)

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
