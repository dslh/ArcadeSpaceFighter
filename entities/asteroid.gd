extends RigidBody2D


var hp: int = 10


func _ready() -> void:
	var start_impulse: Vector2 = (Vector2.ZERO - get_global_position())*randf()
	apply_central_impulse(start_impulse)


func take_damage(value: int = 1) -> void:
	hp -= value
	
	if hp <= 0:
		EventBus.emit_signal("asteroid_destroyed", 10)
		queue_free()
	else:
		pass
