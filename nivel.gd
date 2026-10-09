extends Node2D

var monedas := 0
var total := 0
var vidas := 3
var inicio := Vector2.ZERO
var terminado := false
var proteccion := 0.0

@onready var jugador: CharacterBody2D = $Jugador
@onready var texto_monedas: Label = $HUD/Margen/Fila/Monedas
@onready var barra_vidas: ProgressBar = $HUD/Margen/Fila/Vidas
@onready var mensaje: Label = $HUD/Mensaje

func _ready() -> void:
	inicio = jugador.position
	for moneda in $Monedas.get_children():
		moneda.recogida.connect(_on_moneda_recogida)
		total += 1
	for peligro in $Peligros.get_children():
		peligro.tocado.connect(perder_vida, CONNECT_DEFERRED)
	actualizar_hud()

func _physics_process(delta: float) -> void:
	proteccion = maxf(proteccion - delta, 0.0)
	if not terminado and jugador.position.y > 300 and proteccion <= 0.0:
		# También aplazamos los cambios de escena originados por una caída.
		perder_vida.call_deferred()

func _on_moneda_recogida() -> void:
	if terminado:
		return
	monedas += 1
	actualizar_hud()
	if monedas == total:
		terminado = true
		jugador.movimiento_activo = false
		mensaje.text = "¡Ganaste!"
		mensaje.show()
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://menu.tscn")

func perder_vida() -> void:
	# Una misma colisión solo puede descontar una vida.
	if terminado or proteccion > 0.0:
		return
	vidas -= 1
	proteccion = 0.6
	jugador.position = inicio
	jugador.velocity = Vector2.ZERO
	$Jugador/Camera2D.reset_smoothing()
	actualizar_hud()
	if vidas <= 0:
		terminado = true
		jugador.movimiento_activo = false
		get_tree().change_scene_to_file("res://menu.tscn")

func actualizar_hud() -> void:
	texto_monedas.text = "Monedas: %d / %d" % [monedas, total]
	barra_vidas.value = vidas
