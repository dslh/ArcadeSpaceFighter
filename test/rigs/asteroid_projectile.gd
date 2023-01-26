extends Node2D

export(PackedScene) var projectile_scene

const ASTEROID_POS = Vector2(500.0, 500.0)
const PROJECTILE_POS = Vector2(100.0, 500.0)

const BOUNDS = Rect2(
	Vector2.ZERO, Vector2(1000, 1000)
)

var asteroid: Asteroid = null
var projectiles = null

# Called when the node enters the scene tree for the first time.
func _ready():
	create_asteroid()
	fire_projectile()

func create_asteroid():
	free_entity(asteroid)
	
	asteroid = Asteroid.new()
	asteroid.set_position(ASTEROID_POS)
	$entity_container.add_child(asteroid)

func fire_projectile():
	var projectile = projectile_scene.instance() as Projectile2D
	projectile.set_position(PROJECTILE_POS)
	projectile.set_direction((ASTEROID_POS - PROJECTILE_POS).normalized())
	$entity_container.add_child(projectile)

func free_entity(entity):
	if entity and is_instance_valid(entity):
		entity.queue_free()

func _process(delta):
	for entity in $entity_container.get_children():
		if not BOUNDS.has_point(entity.get_position()):
			entity.queue_free()

func _on_fire_timeout():
	fire_projectile()

func _on_respawn_timeout():
	create_asteroid()
