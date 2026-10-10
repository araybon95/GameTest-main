extends RefCounted
## Original synthesized footfalls; no sampled or third-party sound assets.
static var streams: Dictionary = {}

static func footstep(surface: String) -> AudioStreamWAV:
	if streams.has(surface): return streams[surface]
	var sample_rate: int = 22050
	var length: int = int(sample_rate * 0.17)
	var pcm := PackedByteArray()
	pcm.resize(length*2)
	var noise_seed: int = 317
	for index in range(length):
		var t: float = float(index)/sample_rate
		noise_seed = (noise_seed*16807)%2147483647
		var noise: float = float(noise_seed)/1073741823.5-1.0
		var stone: bool = surface in ["keep","medical"]
		var thud: float = sin(TAU*(91.0 if stone else 64.0)*t)*exp(-t*40.0)
		var grit: float = noise*exp(-t*(55.0 if stone else 28.0))*(0.18 if stone else 0.28)
		var start: float = minf(t*600.0,1.0)
		var value: int = int(clampf((thud*0.58+grit)*start,-1,1)*22000)
		pcm.encode_s16(index*2,value)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.data = pcm
	streams[surface] = stream
	return stream
