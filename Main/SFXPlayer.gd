extends AudioStreamPlayer
class_name SFXPlayer

@export var sfxs : Array[AudioStream]

func go_back_sfx():
	pitch_scale = 1
	stream = sfxs[0]
	play()
	
func hit_sfx(pitch_amplifier: float):
	pitch_scale = min(1 + (pitch_amplifier * 0.05),4)
	stream = sfxs[1]
	play()
	
func points_sfx():
	pitch_scale = 1
	stream = sfxs[2]
	play()
	
func power_up_pick_up_sfx():
	pitch_scale = 1.5
	stream = sfxs[2]
	play()
	
	
func press_button_sfx():
	pitch_scale = 1
	stream = sfxs[3]
	play()
	
func winner_sfx():
	print("pitch_scale: ", pitch_scale)
	pitch_scale = 1
	stream = sfxs[4]
	play()
