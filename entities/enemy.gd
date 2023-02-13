extends RigidBody2D

const THRUST_IMPULSE_FACTOR = 20.0

export(PackedScene) var projectile

var hp: int = 6

var player: Node


func _physics_process(delta: float) -> void:
	var thrust_impulse: Vector2

	if player:
		thrust_impulse = global_position.direction_to(player.get_global_position())
		_fire_projectile()
	else:
		thrust_impulse = global_position.direction_to(Vector2.ZERO)

	$Shapes.rotation += delta

	apply_central_impulse(thrust_impulse * THRUST_IMPULSE_FACTOR)


func take_damage(value: int = 1) -> void:
	hp -= value

	if hp <= 0:
		EventBus.emit_signal("ufo_destroyed", 100)
		queue_free()
	else:
		pass


func _fire_projectile() -> void:
	if $ShootTimer.is_stopped() and $VisibilityNotifier2D.is_on_screen():
		var p1 = projectile.instance() as Projectile2D
		p1.set_position(get_global_position())
		# negative transform to direct the projectile away from the ship
		p1.set_direction(global_position.direction_to(player.get_global_position()))
		p1.add_collision_exception_with(self)
		$ProjectileContainer.add_child(p1)
		$ShootTimer.start(2.0)


func _on_PlayerSensor_body_entered(body: Node) -> void:
	if player:
		return

	if body.is_in_group("player"):
		player = body

