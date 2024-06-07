extends CharacterBody3D
class_name Bola

@export var initial_speed : float = 12
@export var fator_de_aumento_da_velocidade : float = 0.25
@export var fator_de_diminuir_a_velocidade : float = 0.20
@export var sfx_player : SFXPlayer

@export var velocidade_maxima = 65

var direction : Vector3 = Vector3(1,0,1)

var speed : float

func _ready():
	set_physics_process(false)
	speed = initial_speed
	
func _physics_process(delta):
	
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null:
		sfx_player.hit_sfx(speed)
		aumentar_velocidade()
		
		if collision.get_normal().z != 0:
			direction.z = -direction.z
		if collision.get_normal().x != 0:
			direction.x = -direction.x
			
		movement = direction * speed * delta
		move_and_collide(movement)
	
func resetar(position: Vector3, para_a_direita: bool) -> void:
	self.global_position = position
	speed = initial_speed
	direction = gerar_angulo_aleatorio(para_a_direita)
	
func parar(position: Vector3) -> void:
	self.global_position = position
	set_physics_process(false)

func gerar_angulo_aleatorio(para_a_direita: bool) -> Vector3:
	var angle : float
	
	if para_a_direita:
		angle = randf_range(deg_to_rad(35), deg_to_rad(75))
		if randi() % 2 == 0:
			angle = deg_to_rad(360) - angle
	else:
		angle = randf_range(deg_to_rad(105), deg_to_rad(145))
		if randi() % 2 == 0:
			angle = deg_to_rad(360) - angle
			
	var direction = Vector3(cos(angle),0, sin(angle))
	
	return direction.normalized()
		
func diminuir_velocidade() -> void:
	speed = max(speed - speed * fator_de_diminuir_a_velocidade, 6)
	
func aumentar_velocidade() -> void:
	speed = min(speed + (speed * fator_de_aumento_da_velocidade),velocidade_maxima)
