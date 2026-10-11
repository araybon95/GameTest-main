"""Generate original replaceable combat accents; no downloaded sound assets required."""
from pathlib import Path
import math
import random
import struct
import wave

OUTPUT = Path(__file__).resolve().parents[1] / "assets/audio/combat"
RATE = 44100

def render(kind, duration):
    rng = random.Random(1701)
    noise = 0.0
    values = []
    for index in range(int(RATE * duration)):
        time = index / RATE
        progress = time / duration
        noise = noise * 0.84 + rng.uniform(-1, 1) * 0.16
        if kind == "impact":
            envelope = min(1, time / .002) * math.exp(-time * 24)
            value = envelope * (.55 * noise + .32 * math.sin(2 * math.pi * (105 * time - 65 * time * time)))
        elif kind == "death":
            envelope = min(1, time / .015) * (1-progress)**2
            value = envelope * (.25 * noise + .26 * math.sin(2 * math.pi * (100 * time - 40 * time * time)))
        else:
            envelope = min(1, time / .08) * (1-progress)**1.7
            pitch = 58 if kind == "boss" else 73
            value = envelope * (.16 * noise + .20 * math.sin(2 * math.pi * pitch * time)
                + .10 * math.sin(2 * math.pi * pitch * 1.49 * time) + .08 * math.sin(2 * math.pi * pitch * 2.01 * time))
        values.append(struct.pack('<h', round(max(-.85, min(.85, value)) * 32767)))
    with wave.open(str(OUTPUT / f'{kind}.wav'), 'wb') as sound:
        sound.setparams((1, 2, RATE, len(values), 'NONE', 'not compressed'))
        sound.writeframes(b''.join(values))

if __name__ == '__main__':
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for kind, duration in [('impact', .23), ('death', .48), ('boss', 1.2), ('phase', 1.0)]:
        render(kind, duration)
        print(f'Generated {kind}.wav')
