extends Area2D


var id: String = "health"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Health_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.increase_health(5)
		EventBus.emit_signal("powerup_collected", id)
		queue_free()
