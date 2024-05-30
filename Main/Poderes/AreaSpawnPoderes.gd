extends Node3D

@export var timer : Timer
@export var limite_superior : Marker3D
@export var limite_inferior : Marker3D
@export var poderes : Array[PackedScene]
@export_range(1,5,1) var numero_poderes_maximo
@export var node_spawnar : Node

var poderes_spawnados := 0

var ativado := false : set = togglar

func _ready():
	set_multiplayer_authority(1)

func togglar(p_ativado: bool) -> void:
	ativado = p_ativado
	
	if ativado:
		timer.start(3)
	else:
		timer.stop()

func _on_timer_timeout():
	
	if poderes_spawnados >= numero_poderes_maximo or not ativado:
		return
	
	poderes_spawnados += 1
	var lim_inferior = limite_inferior.global_position
	var lim_superior = limite_superior.global_position
	
	var spawn_posicao = Vector3(randf_range(lim_inferior.x,lim_superior.x),0, randf_range(lim_inferior.z,lim_superior.z))
	
	spawnar_poder.rpc(spawn_posicao, randi_range(0,poderes.size()-1))
	
@rpc("any_peer","call_local","reliable")
func spawnar_poder(spawn_posicao: Vector3, poder_index: int) -> void:
	
	var poder = poderes[poder_index]
	
	var poder_instancia = poder.instantiate()
	
	poder_instancia.tree_exited.connect(poder_despawnado)

	node_spawnar.add_child(poder_instancia)
	poder_instancia.global_position = spawn_posicao

func poder_despawnado():
	poderes_spawnados -= 1
