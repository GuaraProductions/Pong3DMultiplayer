extends Node3D

@export var bola : Bola
@export var marcador : Marker3D

@export var player1: Player
@export var player2: Player

@export var gol_player1 : Area3D
@export var gol_player2 : Area3D

@export var spawner_de_poder : Node3D

var player1_spawn : Vector3
var player2_spawn : Vector3

var jogo_iniciado : bool = false

func _ready():
	player1_spawn = player1.global_position
	player2_spawn = player2.global_position
	
func reset():
	player1.global_position = player1_spawn
	player2.global_position = player2_spawn
	bola.visible = false
	parar_bola()
	resetar_bola(true)
	spawner_de_poder.ativado = false
	spawner_de_poder.remover_todos_poderes()
	gol_player1.set_deferred("monitoring", true)
	gol_player2.set_deferred("monitoring", true)
	jogo_iniciado = false

func preparar_jogo_para_multiplayer(lado_esquerdo: bool = true) -> void:

	if lado_esquerdo:
		player1.configurar_controles(1)

	else:
		player2.configurar_prioridade()
		player2.configurar_controles(1)
		gol_player1.set_deferred("monitoring", false)
		gol_player2.set_deferred("monitoring", false)
		começar_jogo.rpc(true)

@rpc("any_peer","reliable","call_local")
func começar_jogo(eh_multiplayer: bool = false):

	if eh_multiplayer:
		
		if multiplayer.get_unique_id() == 1:
			player2.configurar_prioridade(multiplayer.get_remote_sender_id())
			spawner_de_poder.ativado = true
			
	else:
		player1.configurar_controles(1)
		player2.configurar_controles(2)
		spawner_de_poder.ativado = true
		
	jogo_iniciado = true
	bola.visible = true
	bola.resetar(marcador.global_position, randi() % 2)
	bola.set_physics_process(true)

func resetar_bola(para_a_direita: bool) -> void:
	bola.resetar(marcador.global_position, para_a_direita)

func parar_bola() -> void:
	bola.parar(marcador.global_position)

func _on_gol_player_1_body_entered(body):
	resetar_bola(true)

func _on_gol_player_2_body_entered(body):
	resetar_bola(false)
