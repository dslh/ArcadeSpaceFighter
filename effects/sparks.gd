class_name Sparks

static func emit_from_collisions(state, sparks, container):
	for i in state.get_contact_count():
		var normal = state.get_contact_local_normal(i)

		var emitter = sparks.instance()
		emitter.position = state.get_contact_collider_position(i)
		emitter.process_material.direction = Vector3(normal.x, normal.y, 0)
		container.add_child(emitter)
