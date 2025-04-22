extends AudioStreamPlayer
class_name Microfone

var index : int
var effect : AudioEffectCapture
@export var other_player_audio: AudioStreamPlayer
var playback : AudioStreamGeneratorPlayback

var input_threshold : float = 0.005

var receive_buffer : PackedFloat32Array = PackedFloat32Array()

func _ready() -> void:
	set_process(false)
	
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		process_microphone()
	process_player_voice()
	
func process_microphone() -> void:
	var sterio_data : PackedVector2Array = effect.get_buffer(effect.get_frames_available())
	if sterio_data.size() > 0:

		var data = PackedFloat32Array()
		
		data.resize(sterio_data.size())
		var max_amplitude := 0.0
		
		for i in range(sterio_data.size()):
			var value = (sterio_data[i].x + sterio_data[i].y) / 2
			max_amplitude = max(value, max_amplitude)
			data[i] = value
			
		if max_amplitude < input_threshold:
			return

		send_data.rpc(data)
		
func process_player_voice() -> void:

	if receive_buffer.size() <= 0:
		return
		
	#print("mandado dados...", receive_buffer)
		
	for i in range(min(playback.get_frames_available(), receive_buffer.size())):
		playback.push_frame(Vector2(receive_buffer[0], receive_buffer[0]))
		receive_buffer.remove_at(0)
		
@rpc("any_peer","unreliable_ordered")
func send_data(data: PackedFloat32Array) -> void:
	#print("here is data: ", data)
	receive_buffer.append_array(data)


func configurar_audio(id: int) -> void:
	
	print("configurar_audio multiplayer_unique_id: ", id)
	
	set_multiplayer_authority(id)

	await get_tree().create_timer(0.1).timeout

	if is_multiplayer_authority():
		stream = AudioStreamMicrophone.new()
		play()
		index = AudioServer.get_bus_index("Record")
		effect = AudioServer.get_bus_effect(index, 0)
		
		
	other_player_audio.play()
	playback = other_player_audio.get_stream_playback()
	set_process(true)

func fechar() -> void:
	stream = null
	stop()
	set_process.call_deferred(false)

func finalizar_audio() -> void:
	stream = null
	set_process(true)
