extends Resource
class_name PlayerControl

@export var up : String
@export var down : String
@export var sprint : String

func _init(p_up: String = "player1_up", p_down: String = "player1_down", p_sprint: String = "player1_sprint"):
	up = p_up
	down = p_down
	sprint = p_sprint
