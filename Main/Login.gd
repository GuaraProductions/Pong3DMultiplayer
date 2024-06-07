extends MarginContainer

signal logar(ip : String, port_number : int, nickname : String)
signal criar_server(ip : String, port_number : int, nickname : String)

@export var ip : TextEdit
@export var port : TextEdit
@export var nickname : TextEdit

func _on_logar_pressed():
	if not _is_valid_ip_port_number(port.text) or not _is_valid_ip_address(ip.text):
		OS.alert("Porta ou ip inválido!")
	else:
		logar.emit(ip.text.strip_edges(), int(port.text.strip_edges()), nickname.text.strip_edges())

func _on_criar_server_pressed():
	if not _is_valid_ip_port_number(port.text):
		OS.alert("Error! porta inválida")
	else:
		criar_server.emit(ip.text.strip_edges(), int(port.text.strip_edges()), nickname.text.strip_edges())

func _is_valid_ip_address(ip: String):
	return ip.is_valid_ip_address() or ip == "localhost"
	
func _is_valid_ip_port_number(port: String):
	return port.is_valid_int() and port.length() <= 5
