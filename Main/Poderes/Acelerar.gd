extends Area3D

func _on_body_entered(body: Bola):
	body.aumentar_velocidade()
	queue_free()
