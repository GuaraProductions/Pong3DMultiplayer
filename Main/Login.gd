extends MarginContainer

signal logar(ip : String, port_number : int, nickname : String)
signal criar_server(ip : String, port_number : int, nickname : String)

@export var ip : TextEdit
@export var port : TextEdit
@export var nickname : TextEdit

func _on_logar_pressed():
	logar.emit(ip.text, int(port.text), nickname.text)

func _on_criar_server_pressed():
	criar_server.emit(ip.text, int(port.text), nickname.text)
