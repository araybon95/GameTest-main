"""Read-only pixel guard for the 16 composited review frames (Pillow + NumPy)."""
from pathlib import Path
import json
import hashlib
import sys
import numpy as np
from PIL import Image

directory = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).parent / 'preview/frames'
assert (directory / 'frame_00.png').is_file(), 'Composited walking frames are missing'
metadata = json.loads((Path(__file__).parent / 'godot/poses.json').read_text())
root_point = np.array([305.0, 420.0])
yy, xx = np.mgrid[:470, :590]
points = np.stack([xx + 0.5, yy + 0.5], axis=-1) - root_point

def inside(polygon):
    hit = np.zeros((470, 590), dtype=bool)
    for a, b in zip(polygon, np.roll(polygon, -1, axis=0)):
        if a[1] == b[1]:
            continue
        crossing = (a[1] > points[:, :, 1]) != (b[1] > points[:, :, 1])
        edge = (b[0]-a[0])*(points[:, :, 1]-a[1])/(b[1]-a[1])+a[0]
        hit ^= crossing & (points[:, :, 0] < edge)
    return hit

for group in range(4):
    original = np.asarray(Image.open(directory / f'original_{group}.png').convert('RGBA'))
    assert original.shape == (470, 590, 4)
    raw = metadata['frames'][group]
    scale = 280.0 / raw['region'][3]
    source_origin = np.array([raw['region'][2]*0.5, raw['region'][3]])
    protected_gear = np.zeros((470, 590), dtype=bool)
    for key in ['gear_mask', 'shaft_mask']:
        protected_gear |= inside((np.array(raw[key])-source_origin)*scale)
    for step in range(4):
        candidate = np.asarray(Image.open(directory / f'frame_{group*4+step:02d}.png').convert('RGBA'))
        assert candidate.shape == original.shape
        assert np.array_equal(candidate[:275], original[:275]), f'Upper body changed in pose {group*4+step}'
        assert np.array_equal(candidate[:305], original[:305]), f'Hip-plate join changed in pose {group*4+step}'
        assert np.array_equal(candidate[protected_gear], original[protected_gear]), f'Weapon/hand protection changed in pose {group*4+step}'
        if step == 0:
            assert np.array_equal(candidate, original), f'Original key pose changed in pose {group*4}'

source = Path(__file__).parent / 'godot/assets'
manifest = json.loads((source.parent / 'tweens.json').read_text())
assert hashlib.sha256((source / manifest['source_file']).read_bytes()).hexdigest() == manifest['source_sha256']
sheet = np.asarray(Image.open(source / manifest['source_file']).convert('RGBA'))
for index, frame in enumerate(manifest['frames']):
    x, y, w, h = frame['region']
    # Atlas capes/neighbor toe tips can cross nominal grid lines. Measured
    # regions include a right margin; inspect forward toes in the bottom 20%.
    lower = sheet[y+int(h*.8):y+h, x:x+w, 3]
    assert not np.any(lower[:, -1] > 40), f'Boot silhouette clipped at source cell edge {index}'
    assert not np.any(lower[-1] > 40), f'Boot silhouette clipped at source cell bottom {index}'
print('WARDEN_FRAMES_OK: 16 poses, exact upper pixels, protected weapon/hands, original key poses, generated-source hash, unclipped source boots')
