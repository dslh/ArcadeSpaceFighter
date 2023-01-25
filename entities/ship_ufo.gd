# --- Class ---
class_name UFO

# --- Extends ---
extends Ship2D

# --- Siganls ---


# --- ENUMS ---


# --- Constants ---
const THRUST_IMPULSE_FACTOR = 20.0

# --- Exported Variables ---


# --- Public Variables ---
var player: Node

# --- Private Variables ---


# --- Onready Variables ---


# --- Virtual _init method ---


# --- Virtual _ready method ---
func _ready() -> void:
	add_to_group("enemy")

# --- Virtual methods ---
func _physics_process(delta: float) -> void:
	var thrust_impulse: Vector2
	
	if player:
		thrust_impulse = global_position.direction_to(player.get_global_position())
		_fire_projectile(
			get_global_position(),
			global_position.direction_to(player.get_global_position()),
			self,
			$ProjectileContainer
		)
	else:
		thrust_impulse = global_position.direction_to(Vector2.ZERO)
	
	$Shapes.rotation += delta
	
	apply_central_impulse(thrust_impulse * THRUST_IMPULSE_FACTOR)


# --- Public methods ---


# --- Private methods ---
func _on_PlayerSensor_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body



# --- SetGet functions ---

