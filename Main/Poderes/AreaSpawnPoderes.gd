extends Node3D

signal matar_todos_poderes

@export var timer : Timer
@export var limite_superior : Marker3D
@export var limite_inferior : Marker3D
@export var poderes : Array[PackedScene]
@export_range(1,5,1) var numero_poderes_maximo
@export var node_spawnar : Node
@export var sfx_player : SFXPlayer

@export var multiplayer_spawner : MultiplayerSpawner

var poderes_spawnados := []

var ativado := false : set = togglar

func _ready():
	multiplayer_spawner.spawn_path = node_spawnar.get_path()
	multiplayer_spawner.spawn_function = spawnar_poder

func togglar(p_ativado: bool) -> void:
	ativado = p_ativado
	
	if ativado:
		timer.start(3)
	else:
		timer.stop()

func remover_todos_poderes():
	matar_todos_poderes.emit()
	multiplayer_spawner.clear_spawnable_scenes()

func _on_timer_timeout():
	
	if poderes_spawnados.size() >= numero_poderes_maximo or not ativado:
		return
	
	var lim_inferior = limite_inferior.global_position
	var lim_superior = limite_superior.global_position
	
	var spawn_posicao = Vector3(randf_range(lim_inferior.x,lim_superior.x),0, randf_range(lim_inferior.z,lim_superior.z))
	
	multiplayer_spawner.spawn({"index": randi_range(0,poderes.size()-1), "spawn_posicao": spawn_posicao})
	
func spawnar_poder(data: Variant) -> Node:
	
	var poder = poderes[data.index]
	
	var poder_instancia = poder.instantiate()
	
	matar_todos_poderes.connect(poder_instancia.queue_free)
	poder_instancia.tree_exited.connect(poder_despawnado.bind(poder_instancia))
	poderes_spawnados.append(poder_instancia)
	
	poder_instancia.set_deferred("global_position", data.spawn_posicao)
	return poder_instancia

func poder_despawnado(poder_instancia):
	poderes_spawnados.erase(poder_instancia)
	sfx_player.power_up_pick_up_sfx()
