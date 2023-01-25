# ---------------------------------------------------
# Class
# ---------------------------------------------------
class_name Ship2D
# ---------------------------------------------------
# Extends
# ---------------------------------------------------
extends Entity2D

# ---------------------------------------------------
# Siganls
# ---------------------------------------------------

# ---------------------------------------------------
# ENUMS
# ---------------------------------------------------

# ---------------------------------------------------
# Constants
# ---------------------------------------------------
const MAX_HP:int = 10
# ---------------------------------------------------
# Exported Variables 
# ---------------------------------------------------

# ---------------------------------------------------
# Public Variables
# ---------------------------------------------------
var bouncing_bullets_active: bool = false setget set_bouncing_bullets_active
# ---------------------------------------------------
# Private Variables
# ---------------------------------------------------

# ---------------------------------------------------
# Onready Variables
# ---------------------------------------------------

# ---------------------------------------------------
# Virtual _init method
# ---------------------------------------------------

# ---------------------------------------------------
# Virtual _ready method
# ---------------------------------------------------

# ---------------------------------------------------
# Virtual methods
# ---------------------------------------------------

# ---------------------------------------------------
# Public methods
# ---------------------------------------------------

func apply_health_powerup(value: int = 1) -> void:
	# HP can not go over MAX_HP
	var max_change = MAX_HP - hp
	# negate the damage to cause HP to increase
	if max_change < value:
		take_damage(-max_change)
	else:
		take_damage(-value)


# ---------------------------------------------------
# Private methods
# ---------------------------------------------------

func _fire_projectile(pos: Vector2, dir: Vector2, exception: Node, container: Node) -> void:
	var p: Projectile2D = Projectile2D.new(8, exception)
	p.set_position(pos)
	randomize()
	var rot: float = 0.0 + (float(bouncing_bullets_active) * rand_range(-0.2, 0.2))
	p.set_direction(dir.rotated(rot))
	p.set_can_bounce(bouncing_bullets_active)
	container.add_child(p)



# ---------------------------------------------------
# SetGet functions
# ---------------------------------------------------
func set_bouncing_bullets_active(value: bool = false) -> void:
	bouncing_bullets_active = value
