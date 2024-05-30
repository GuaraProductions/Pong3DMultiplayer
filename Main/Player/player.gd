extends CharacterBody3D
class_name Player

@export var controls : PlayerControl
@export var speed = 15.0

var player1_controls = preload("res://Main/Player/Player1.tres")
var player2_controls = preload("res://Main/Player/Player2.tres")

func configurar_prioridade(id: int = multiplayer.get_unique_id()) -> void:
	set_multiplayer_authority(id)
	
func configurar_controles(num: int):
	
	match num:
		1:
			controls = player1_controls
		2:
			controls = player2_controls
			
	set_physics_process(true)

func _physics_process(delta):
	
	if controls == null:
		set_physics_process(false)
		return

	var input_vector := Vector3.ZERO
	
	input_vector.z = Input.get_action_strength(controls.down) - Input.get_action_strength(controls.up)
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector3.ZERO:

		velocity = input_vector * speed
		
	else:
		velocity = Vector3.ZERO
		
	move_and_slide()
