extends AudioStreamPlayer

@export var possible_musics : Array[AudioStream]

func _ready():
	
	var music = possible_musics[randi_range(0,possible_musics.size()-1)]
	self.stream = music
	self.play()


func _on_finished():
	var music = possible_musics[randi_range(0,possible_musics.size()-1)]
	self.stream = music
	self.play()
