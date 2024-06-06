extends MarginContainer

signal player1_ganhou()
signal player2_ganhou()

@export var placar_maximo : int = 5

@export var player_1_win_color : Color = Color.ROYAL_BLUE
@export var player_2_win_color : Color = Color.INDIAN_RED

@export var placar_player_1 : Label
@export var placar_player_2 : Label

@export var player1_nome : Label
@export var player2_nome : Label

@export var texto_vencedor : Label
@export var pos_partida : VBoxContainer

@export var sfx_player : SFXPlayer

var jogo_acabou : bool = false

func _ready():
	pos_partida.visible = false

func reset(resetar_nomes: bool = true):
	
	if resetar_nomes:
		player2_nome.text = ""
		
	placar_player_1.text = "0"
	placar_player_2.text = "0"
	pos_partida.visible = false
	texto_vencedor.text = ""
	jogo_acabou = false

func _on_gol_player_1_body_entered(body):
	
	if jogo_acabou:
		return
	
	atualizar_placar_gol_player2.rpc()

@rpc("any_peer","call_local")
func atualizar_placar_gol_player2():
	var placar_inteiro := int(placar_player_2.text) + 1
	
	if placar_inteiro == placar_maximo:
		player2_ganhou.emit()
		mostrar_vencendor(player_2_win_color, player2_nome.text)
	else:
		sfx_player.points_sfx()
	
	placar_player_2.text = str(placar_inteiro)

func _on_gol_player_2_body_entered(body):
	
	if jogo_acabou:
		return
		
	atualizar_placar_gol_player1.rpc()
	
@rpc("any_peer","call_local")
func atualizar_placar_gol_player1():
	var placar_inteiro := int(placar_player_1.text) + 1
	
	if placar_inteiro == placar_maximo:
		player1_ganhou.emit()
		mostrar_vencendor(player_1_win_color, player1_nome.text)
	else:
		sfx_player.points_sfx()
	
	placar_player_1.text = str(placar_inteiro)
	
func mostrar_vencendor(vencedor_cor : Color, vencedor_nome: String):
	sfx_player.winner_sfx()
	pos_partida.visible = true
	texto_vencedor.label_settings.font_color = vencedor_cor
	texto_vencedor.visible = true
	texto_vencedor.text = "%s\nVenceu!" % [vencedor_nome]
	jogo_acabou = true

@rpc("any_peer","call_local")
func atualizar_nome_convidado(nome_jogador2: String):
	player2_nome.text = nome_jogador2

@rpc("any_peer","call_local")
func atualizar_nome_host(nome_jogador1: String):
	player1_nome.text = nome_jogador1
