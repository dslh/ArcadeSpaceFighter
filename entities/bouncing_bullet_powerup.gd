extends Area2D

var id: String = "bouncing"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_BouncingBullletPowerup_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.set_bouncing_bullets_active(true)
		EventBus.emit_signal("powerup_collected", id)
		queue_free()
