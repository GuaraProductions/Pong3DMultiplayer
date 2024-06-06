extends MarginContainer

@export var tela_som : ColorRect

func _ready():
	tela_som.visible = false

func _on_abrir_som_pressed():
	tela_som.visible = true

func _on_sair_botao_pressed():
	tela_som.visible = false

func _on_musica_slider_value_changed(value):
	var db = -pow(8.0 -value, 1.8)
	AudioServer.set_bus_volume_db(1,db)

func _on_sfx_slider_value_changed(value):
	var db = -pow(8.0 -value, 1.8)
	AudioServer.set_bus_volume_db(2,db)
