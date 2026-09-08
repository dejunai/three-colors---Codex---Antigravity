extends Node

# Zero-dependency, engine-native procedural audio scaffold.
# Synthesizes period-appropriate diegetic audio:
# 1. Static Pop: sharp 35mm optical pop / projection splice snap.
# 2. Dry Cough: faint, hollow, two-stage rasping cough.

var pop_stream: AudioStreamWAV
var cough_stream: AudioStreamWAV
var drip_stream: AudioStreamWAV
var sfx_player: AudioStreamPlayer
var is_headless: bool = false

func _ready() -> void:
	is_headless = DisplayServer.get_name() == "headless"
	_synthesize_streams()
	_setup_players()

func _synthesize_streams() -> void:
	pop_stream = _build_pop()
	cough_stream = _build_cough()
	drip_stream = _build_drip()

func _setup_players() -> void:
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SfxPlayer"
	sfx_player.bus = "Master"
	sfx_player.volume_db = -6.0
	add_child(sfx_player)

func play_glitch() -> void:
	if is_headless or pop_stream == null or sfx_player == null: return
	sfx_player.stream = pop_stream
	sfx_player.volume_db = -4.0
	sfx_player.pitch_scale = randf_range(0.92, 1.08)
	sfx_player.play()

func play_cough() -> void:
	if is_headless or cough_stream == null or sfx_player == null: return
	sfx_player.stream = cough_stream
	sfx_player.volume_db = -8.0
	sfx_player.pitch_scale = randf_range(0.96, 1.04)
	sfx_player.play()

func _build_pop() -> AudioStreamWAV:
	var sample_rate = 22050
	var samples = int(sample_rate * 0.07) # 70ms
	var bytes = PackedByteArray()
	bytes.resize(samples * 2)

	for i in samples:
		var t = float(i) / sample_rate
		var env = exp(-t * 85.0)
		var noise = (randf() * 2.0 - 1.0)
		var pop = sin(t * 880.0 * TAU) * 0.6 + noise * 0.4
		var sample_val = int(clampf(pop * env * 22000.0, -32768.0, 32767.0))
		bytes.encode_s16(i * 2, sample_val)

	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = bytes
	return wav

func _build_cough() -> AudioStreamWAV:
	var sample_rate = 22050
	var total_dur = 0.58
	var samples = int(sample_rate * total_dur)
	var bytes = PackedByteArray()
	bytes.resize(samples * 2)

	var prev_sample = 0.0
	for i in samples:
		var t = float(i) / sample_rate
		var env = 0.0
		if t < 0.16:
			env = sin((t / 0.16) * PI) * 0.45
		elif t > 0.18 and t < 0.54:
			var t2 = (t - 0.18) / 0.36
			env = sin(t2 * PI) * exp(-t2 * 2.2) * 0.7

		var noise = randf() * 2.0 - 1.0
		var throat = sin(t * 320.0 * TAU) * 0.3 + sin(t * 640.0 * TAU) * 0.15
		var raw = (noise * 0.65 + throat * 0.35) * env
		prev_sample = lerpf(prev_sample, raw, 0.45)
		var sample_val = int(clampf(prev_sample * 24000.0, -32768.0, 32767.0))
		bytes.encode_s16(i * 2, sample_val)

	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = bytes
	return wav

func play_drip() -> void:
	if is_headless or drip_stream == null or sfx_player == null: return
	sfx_player.stream = drip_stream
	sfx_player.volume_db = -12.0
	sfx_player.pitch_scale = randf_range(0.88, 1.15)
	sfx_player.play()

func _build_drip() -> AudioStreamWAV:
	var sample_rate = 22050
	var total_dur = 0.12
	var samples = int(sample_rate * total_dur)
	var bytes = PackedByteArray()
	bytes.resize(samples * 2)

	for i in samples:
		var t = float(i) / sample_rate
		var env = exp(-t * 45.0)
		var freq = 1200.0 - t * 4000.0
		var s = sin(t * maxf(freq, 200.0) * TAU) * env
		var sample_val = int(clampf(s * 18000.0, -32768.0, 32767.0))
		bytes.encode_s16(i * 2, sample_val)

	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = bytes
	return wav

