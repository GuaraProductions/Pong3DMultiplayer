extends Area3D

func _on_body_entered(body: Bola):
	body.diminuir_velocidade()
	queue_free()
