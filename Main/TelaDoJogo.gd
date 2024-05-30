extends MarginContainer

signal player1_ganhou()
signal player2_ganhou()

@export var placar_maximo : int = 5

@export var player_1_win_color : Color = Color.ROYAL_BLUE
@export var player_2_win_color : Color = Color.INDIAN_RED

@export var placar_player_1 : Label
@export var placar_player_2 : Label
@export var texto_vencedor : Label

var jogo_acabou : bool = false

func _on_gol_player_1_body_entered(body):
	
	if jogo_acabou:
		return
	
	atualizar_placar_gol_player2.rpc()

@rpc("any_peer","call_local")
func atualizar_placar_gol_player2():
	var placar_inteiro := int(placar_player_2.text) + 1
	
	if placar_inteiro == placar_maximo:
		player2_ganhou.emit()
		texto_vencedor.label_settings.font_color = player_2_win_color
		texto_vencedor.visible = true
		texto_vencedor.text = "Player 2\nVenceu!"
		jogo_acabou = true
	
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
		texto_vencedor.label_settings.font_color = player_1_win_color
		texto_vencedor.visible = true
		texto_vencedor.text = "Player 1\nVenceu!"
		jogo_acabou = true
	
	placar_player_1.text = str(placar_inteiro)
