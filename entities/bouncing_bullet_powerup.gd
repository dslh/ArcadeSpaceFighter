extends Area2D


var id: String = "bouncing"


func _on_BouncingBullletPowerup_body_entered(body: Node) -> void:
	if body is Ship2D:
		body.set_bouncing_bullets_active(true)
		EventBus.emit_signal("powerup_collected", id)
		queue_free()
