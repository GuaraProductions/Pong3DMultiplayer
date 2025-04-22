extends Control

@onready var record = $hbox/Record
@onready var play = $hbox/Play
@onready var save = $hbox/Save
@onready var info = $Info
@onready var microphone_stream_player = $microphone

var stereo := true
var mix_rate := 44100  # This is the default mix rate on recordings.
var format := AudioStreamWAV.FORMAT_16_BITS  # This is the default format on recordings.

var effect : AudioEffect
var recording

func _ready():
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("Record")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	effect = AudioServer.get_bus_effect(idx, 0)

func _on_record_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		play.disabled = false
		save.disabled = false
		effect.set_recording_active(false)
		recording.set_mix_rate(mix_rate)
		recording.set_format(format)
		recording.set_stereo(stereo)
		record.text = "Record"
		info.text = ""
	else:
		play.disabled = true
		save.disabled = true
		effect.set_recording_active(true)
		record.text = "Stop"
		info.text = "Recording..."

func _on_play_pressed() -> void:
	print(recording)
	print(recording.format)
	print(recording.mix_rate)
	print(recording.stereo)
	var data = recording.get_data()
	print(data.size())
	microphone_stream_player.stream = recording
	microphone_stream_player.play()

func _on_save_pressed() -> void:
	var save_path = "user://meu_audio.wav"
	recording.save_to_wav(save_path)
	info.text = "Saved WAV file to: %s\n(%s)" % [save_path, ProjectSettings.globalize_path(save_path)]
