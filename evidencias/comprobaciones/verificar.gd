extends SceneTree

var fallos := 0
var comprobaciones := 0

func _initialize() -> void:
	call_deferred("verificar")

func comprobar(condicion: bool, descripcion: String) -> void:
	comprobaciones += 1
	if condicion:
		print("OK: " + descripcion)
	else:
		fallos += 1
		push_error("FALLO: " + descripcion)

func cuadros(cantidad: int) -> void:
	for i in cantidad:
		await physics_frame

func cargar_nivel(path: String = "res://nivel.tscn") -> Node2D:
	change_scene_to_file(path)
	await process_frame
	await process_frame
	return current_scene

func verificar() -> void:
	var nivel := await cargar_nivel()
	var jugador: CharacterBody2D = nivel.get_node("Jugador")
	var suelo: TileMapLayer = nivel.get_node("Suelo")
	comprobar(suelo.get_used_cells().size() == 90, "Mapa: 74 baldosas de suelo y 16 de plataformas")
	comprobar(suelo.get_cell_source_id(Vector2i(18, 10)) == -1 and suelo.get_cell_source_id(Vector2i(20, 11)) == -1, "Hueco entre x=324 y x=378")
	comprobar(suelo.tile_set.tile_size == Vector2i(18, 18), "TileSet de 18 x 18")
	comprobar(suelo.tile_set.get_source(0).get_tile_data(Vector2i(0, 1), 0).get_collision_polygons_count(0) == 1, "Colisiones definidas en el TileSet")
	comprobar(nivel.total == 6 and nivel.vidas == 3, "Seis monedas y tres vidas iniciales")
	await cuadros(35)
	comprobar(jugador.is_on_floor() and absf(jugador.position.y - 168) < 1, "El jugador cae y se sostiene en el suelo")
	Input.action_press("ui_right")
	await cuadros(16)
	comprobar(jugador.velocity.x == 130, "Velocidad horizontal de 130 px/s")
	Input.action_press("ui_accept")
	await cuadros(1)
	Input.action_release("ui_accept")
	await cuadros(34)
	Input.action_release("ui_right")
	await cuadros(2)
	comprobar(jugador.is_on_floor() and absf(jugador.position.y - 114) < 1, "Salto real desde el suelo a P1")
	comprobar(nivel.monedas >= 2, "Recogida real de las monedas del inicio y P1")
	Input.action_press("ui_right")
	await cuadros(14)
	Input.action_press("ui_accept")
	await cuadros(1)
	Input.action_release("ui_accept")
	await cuadros(34)
	Input.action_release("ui_right")
	await cuadros(2)
	comprobar(jugador.is_on_floor() and absf(jugador.position.y - 60) < 1, "Salto real desde P1 a P2")
	Input.action_press("ui_left")
	await cuadros(2)
	comprobar(jugador.get_node("AnimatedSprite2D").flip_h, "El sprite se voltea al caminar a la izquierda")
	Input.action_release("ui_left")
	await cuadros(2)
	comprobar(jugador.get_node("AnimatedSprite2D").animation == &"quieto", "Animación quieto al soltar la dirección")
	var hud: Rect2 = nivel.get_node("HUD/Margen").get_global_rect()
	jugador.position = Vector2(650, 168)
	await cuadros(5)
	comprobar(nivel.get_node("HUD/Margen").get_global_rect() == hud, "HUD permanece fijo al desplazar la cámara")
	jugador.position = Vector2(495, 168)
	jugador.velocity = Vector2.ZERO
	await cuadros(5)
	comprobar(nivel.vidas == 2 and jugador.position.x == 36, "Pinchos descuentan una vida y reaparecen al inicio")
	comprobar(nivel.get_node("HUD/Margen/Fila/Vidas").value == 2, "Barra de vidas sincronizada")
	nivel.proteccion = 0.0
	jugador.position = Vector2(350, 305)
	await cuadros(4)
	comprobar(nivel.vidas == 1 and jugador.position.x == 36, "Caída por el hueco descuenta una vida")
	nivel.proteccion = 0.0
	jugador.position = Vector2(495, 168)
	await cuadros(5)
	comprobar(current_scene.name == "Menu", "Tercera vida perdida regresa al menú")
	current_scene.get_node("Opciones/Jugar").pressed.emit()
	await process_frame
	await process_frame
	nivel = current_scene
	jugador = nivel.get_node("Jugador")
	comprobar(nivel.monedas == 0 and nivel.vidas == 3, "Jugar inicia una partida nueva")
	for moneda in nivel.get_node("Monedas").get_children():
		jugador.position = moneda.position
		jugador.velocity = Vector2.ZERO
		await cuadros(3)
	comprobar(nivel.monedas == 6 and nivel.get_node("Monedas").get_child_count() == 0, "Las seis Area2D emiten recogida y desaparecen")
	comprobar(nivel.get_node("HUD/Mensaje").visible and nivel.terminado, "Victoria visible y movimiento detenido")
	await create_timer(2.2).timeout
	comprobar(current_scene.name == "Menu", "Victoria regresa al menú después de dos segundos")
	nivel = await cargar_nivel("res://nivel_reto.tscn")
	jugador = nivel.get_node("Jugador")
	await cuadros(30)
	jugador.position = Vector2(224, 168)
	Input.action_press("ui_right")
	await cuadros(15)
	Input.action_release("ui_right")
	var caja: RigidBody2D = nivel.get_node("Caja")
	comprobar(caja.position.x > 246, "Reto: el jugador empuja la caja con impulsos")
	print("RESULTADO: %d comprobaciones, %d fallos" % [comprobaciones, fallos])
	quit(1 if fallos else 0)
