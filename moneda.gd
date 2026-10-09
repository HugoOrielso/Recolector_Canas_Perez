extends Area2D

signal recogida
var recolectada := false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador" and not recolectada:
		recolectada = true
		recogida.emit()
		queue_free()
