extends Resource
class_name PlayerControl

@export var up : String
@export var down : String

func _init(p_up: String = "player1_up", p_down: String = "player1_down"):
	up = p_up
	down = p_down
