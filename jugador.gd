extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -360.0
const IMPULSO_CAJA = 20.0

var movimiento_activo := true

func _physics_process(delta: float) -> void:
	if not movimiento_activo:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("quieto")
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("caminar")
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("quieto")
	move_and_slide()
	# Los bordes de la cámara también delimitan el recorrido horizontal.
	position.x = clampf(position.x, 7.0, 713.0)
	# Reto opcional: solo tiene efecto cuando existe una Caja (RigidBody2D).
	for i in get_slide_collision_count():
		var choque := get_slide_collision(i)
		var cuerpo = choque.get_collider()
		if cuerpo is RigidBody2D:
			cuerpo.apply_central_impulse(-choque.get_normal() * IMPULSO_CAJA)
