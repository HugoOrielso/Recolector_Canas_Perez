extends SceneTree

func _initialize() -> void:
	call_deferred("comparar")

func comparar() -> void:
	for impulso in [5.0, 20.0, 100.0]:
		var caja := RigidBody2D.new()
		caja.mass = 1.0
		caja.gravity_scale = 0.0
		caja.linear_damp = 0.0
		caja.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
		var colision := CollisionShape2D.new()
		var forma := RectangleShape2D.new()
		forma.size = Vector2(18, 18)
		colision.shape = forma
		caja.add_child(colision)
		root.add_child(caja)
		await physics_frame
		await physics_frame
		caja.apply_central_impulse(Vector2(impulso, 0))
		await physics_frame
		await physics_frame
		print("Impulso=%.1f, masa=1, velocidad_x=%.1f" % [impulso, caja.linear_velocity.x])
		assert(absf(caja.linear_velocity.x - impulso) < 0.01)
		caja.queue_free()
		await process_frame
	print("Comparacion de impulsos aislados: 3 valores correctos.")
	quit()
