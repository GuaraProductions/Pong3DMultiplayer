extends CharacterBody3D
class_name Bola

@export var initial_speed : float = 12.0
@export var fator_de_aumento_da_velocidade : float = 0.15
@export var fator_de_diminuir_a_velocidade : float = 0.35

var direction : Vector3 = Vector3(1,0,1)

var speed : float

func _ready():
	set_physics_process(false)
	speed = initial_speed
	
func _physics_process(delta):
	
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null:
		
		aumentar_velocidade()
		
		if collision.get_normal().z != 0:
			direction.z = -direction.z
		elif collision.get_normal().x != 0:
			direction.x = -direction.x
		else:
			direction.x = -direction.x
			direction.z = -direction.z
	
func resetar(position: Vector3, para_a_direita: bool) -> void:
	self.global_position = position
	speed = initial_speed
	direction = gerar_angulo_aleatorio(para_a_direita)

func gerar_angulo_aleatorio(para_a_direita: bool) -> Vector3:
	var angle : float
	
	if para_a_direita:
		angle = randf_range(deg_to_rad(15), deg_to_rad(75))
		if randi() % 2 == 0:
			angle = deg_to_rad(360) - angle
	else:
		angle = randf_range(deg_to_rad(105), deg_to_rad(165))
		if randi() % 2 == 0:
			angle = deg_to_rad(360) - angle
			
	var direction = Vector3(cos(angle),0, sin(angle))
	
	return direction.normalized()
		
func diminuir_velocidade() -> void:
	speed = max(speed - speed * fator_de_diminuir_a_velocidade, 6)
	
func aumentar_velocidade() -> void:
	speed += (speed * fator_de_aumento_da_velocidade)