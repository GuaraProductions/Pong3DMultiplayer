extends CanvasLayer

@export var placar : MarginContainer
@export var tela_principal : MarginContainer
@export var tela_login : MarginContainer
@export var game : Node3D

@export var sfx_player : SFXPlayer

var peers := {}

var host_name : String = ""

var players_querem_revanche := []

var multiplayer_ligado : bool = false

func _ready():
	get_tree().paused = true

	placar.visible = false
	tela_principal.visible = true
	tela_login.visible = false

func _on_local_pressed():
	sfx_player.press_button_sfx()
	tela_principal.visible = false
	placar.visible = true
	tela_login.visible = false
	get_tree().paused = false
	placar.atualizar_nome_convidado("Player2")
	placar.atualizar_nome_host("Player1")
	game.começar_jogo()

func _on_multiplayer_pressed():
	tela_principal.visible = false
	tela_login.visible = true
	sfx_player.press_button_sfx()

func _on_login_criar_server(ip, port_number, nickname):
	sfx_player.press_button_sfx()
	var local_peer = ENetMultiplayerPeer.new()
	
	var error = local_peer.create_server(port_number)
	if error != 0:
		OS.alert("Deu ruim")
		return
		
	multiplayer.peer_disconnected.connect(player_desconectou)
	multiplayer.multiplayer_peer = local_peer
	host_name = nickname
	placar.atualizar_nome_host(nickname)
	multiplayer_ligado = true
	preparar_jogo(true)

func _on_login_logar(ip, port_number, nickname):
	sfx_player.press_button_sfx()
	var local_peer = ENetMultiplayerPeer.new()
	
	var error = local_peer.create_client(ip, port_number)
	if error != 0:
		OS.alert("Deu ruim")
		return
		
	multiplayer.multiplayer_peer = local_peer
	
	await multiplayer.connected_to_server
	
	multiplayer.server_disconnected.connect(voltar_tela_principal)
	registrar_peer(nickname, multiplayer.get_unique_id())
	peer_conectado.rpc(nickname)
	placar.atualizar_nome_convidado.rpc(nickname)
	multiplayer_ligado = true
	preparar_jogo(false)
	
func registrar_peer(nickname: String, id: int) -> void:
	peers[id] = nickname
	
@rpc("any_peer", "reliable")
func peer_conectado(nickname: String):
	var peer_id = multiplayer.get_remote_sender_id()
	if multiplayer.is_server():
		placar.atualizar_nome_host.rpc_id(peer_id, host_name)
	registrar_peer(nickname, peer_id)

func preparar_jogo(lado_esquerdo: bool = true):
	tela_principal.visible = false
	placar.visible = true
	tela_login.visible = false
	get_tree().paused = false
	game.preparar_jogo_para_multiplayer(lado_esquerdo)

func _on_revanche_pressed():
	jogadores_querem_revanche.rpc()
	sfx_player.press_button_sfx()
	
@rpc("any_peer","call_local")
func jogadores_querem_revanche():
	
	var id = multiplayer.get_remote_sender_id()
	
	if not id in players_querem_revanche:
		players_querem_revanche.append(id)
	
	if players_querem_revanche.size() >= 2 or (not multiplayer_ligado and players_querem_revanche.size() >= 1):
		preparar_revanche.rpc()
	
@rpc("any_peer","call_local")
func preparar_revanche():
	
	game.reset()
	placar.reset(false)
	
	if multiplayer_ligado:
		if multiplayer.is_server():
			game.preparar_jogo_para_multiplayer(true)
			
		else:
			game.preparar_jogo_para_multiplayer(false)
	else:
		game.começar_jogo()

func _on_sair_pressed():
	sfx_player.press_button_sfx()
	multiplayer.multiplayer_peer.close()
	game.reset()
	placar.reset()
	voltar_tela_principal()
	multiplayer_ligado = false
	
func player_desconectou(id: int):
	game.reset()
	placar.reset()
	multiplayer_ligado = false
	
func voltar_tela_principal():
	get_tree().paused = true
	game.reset()
	placar.visible = false
	tela_principal.visible = true

func _on_back_pressed():
	sfx_player.press_button_sfx()
	placar.visible = false
	tela_principal.visible = true
	tela_login.visible = false 
