extends CanvasLayer

@export var placar : MarginContainer
@export var tela_principal : MarginContainer
@export var tela_login : MarginContainer
@export var game : Node3D

var peers := {}

func _ready():
	get_tree().paused = true

	placar.visible = false
	tela_principal.visible = true
	tela_login.visible = false

func _on_local_pressed():
	tela_principal.visible = false
	placar.visible = true
	tela_login.visible = false
	get_tree().paused = false
	game.começar_jogo()

func _on_multiplayer_pressed():
	tela_principal.visible = false
	tela_login.visible = true


func _on_login_criar_server(ip, port_number, nickname):
	
	var local_peer = ENetMultiplayerPeer.new()
	
	var error = local_peer.create_server(port_number)
	if error != 0:
		OS.alert("Deu ruim")
		return
		
	multiplayer.multiplayer_peer = local_peer
	preparar_jogo(true)

func _on_login_logar(ip, port_number, nickname):
	
	var local_peer = ENetMultiplayerPeer.new()
	
	var error = local_peer.create_client(ip, port_number)
	if error != 0:
		OS.alert("Deu ruim")
		return
		
	multiplayer.multiplayer_peer = local_peer
	
	await multiplayer.connected_to_server
	
	registrar_peer(nickname, multiplayer.get_unique_id())
	peer_conectado.rpc(nickname)
	
	preparar_jogo(false)
	
func registrar_peer(nickname: String, id: int) -> void:
	peers[id] = nickname
	
@rpc("any_peer", "reliable")
func peer_conectado(nickname: String):
	var peer_id = multiplayer.get_remote_sender_id()
	registrar_peer(nickname, peer_id)

func preparar_jogo(lado_esquerdo: bool = true):
	tela_principal.visible = false
	placar.visible = true
	tela_login.visible = false
	get_tree().paused = false
	game.preparar_jogo_para_multiplayer(lado_esquerdo)	
