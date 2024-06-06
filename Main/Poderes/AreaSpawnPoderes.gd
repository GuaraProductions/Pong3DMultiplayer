extends Node3D

signal matar_todos_poderes

@export var timer : Timer
@export var limite_superior : Marker3D
@export var limite_inferior : Marker3D
@export var poderes : Array[PackedScene]
@export_range(1,5,1) var numero_poderes_maximo
@export var node_spawnar : Node
@export var sfx_player : SFXPlayer

var poderes_spawnados := []

var ativado := false : set = togglar

func togglar(p_ativado: bool) -> void:
	ativado = p_ativado
	
	if ativado:
		timer.start(3)
	else:
		timer.stop()

func remover_todos_poderes():
	matar_todos_poderes.emit()

func _on_timer_timeout():
	
	if poderes_spawnados.size() >= numero_poderes_maximo or not ativado:
		return
	
	var lim_inferior = limite_inferior.global_position
	var lim_superior = limite_superior.global_position
	
	var spawn_posicao = Vector3(randf_range(lim_inferior.x,lim_superior.x),0, randf_range(lim_inferior.z,lim_superior.z))
	
	spawnar_poder.rpc(spawn_posicao, randi_range(0,poderes.size()-1))
	
@rpc("any_peer","call_local","reliable")
func spawnar_poder(spawn_posicao: Vector3, poder_index: int) -> void:
	
	var poder = poderes[poder_index]
	
	var poder_instancia = poder.instantiate()
	
	matar_todos_poderes.connect(poder_instancia.queue_free)
	poder_instancia.tree_exited.connect(poder_despawnado.bind(poderes_spawnados.size()))
	poderes_spawnados.append(poder_instancia)

	node_spawnar.add_child(poder_instancia)
	poder_instancia.global_position = spawn_posicao

func poder_despawnado(poder_instancia_index):
	poderes_spawnados.erase(poder_instancia_index)
	sfx_player.power_up_pick_up_sfx()
