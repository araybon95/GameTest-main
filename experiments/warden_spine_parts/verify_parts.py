"""Read-only check of exported cutout ownership and transparent background."""
from pathlib import Path
import hashlib, json
import numpy as np
from PIL import Image

root = Path(__file__).resolve().parent
manifest = json.loads((root/'parts.json').read_text())
source = np.asarray(Image.open(root/'source/warden_parts.png').convert('RGBA'))
assert len(manifest['parts']) == 20
ownership = {}
assert hashlib.sha256((root/'source/warden_parts.png').read_bytes()).hexdigest() == manifest['source_sha256']
assert hashlib.sha256((root/'source/hero_warden_reference.png').read_bytes()).hexdigest() == manifest['reference_sha256']
for part in manifest['parts']:
    filename = root/'images'/(part['name']+'.png')
    image = np.asarray(Image.open(filename).convert('RGBA'))
    x,y,w,h = map(int,part['source_region'])
    assert image.shape == (h,w,4), part['name']+' dimensions'
    mask = np.zeros((h,w),bool)
    for span in part['source_spans']:
        row,start,end = map(int,span)
        assert 0 <= row < h and 0 <= start < end <= w
        mask[row,start:end] = True
    assert np.array_equal(image[mask], source[y:y+h,x:x+w][mask]), part['name']+' source pixels'
    assert not image[~mask].any(), part['name']+' neighboring pixels were included'
    assert mask.sum() > 500, part['name']+' empty attachment'
    assert hashlib.sha256(filename.read_bytes()).hexdigest() == part['sha256']
    if part['name'] in ['mace','shield']:
        owned = np.zeros(source.shape[:2],bool)
        owned[y:y+h,x:x+w] = mask
        ownership[part['name']] = owned
    if part['name'] == 'mace':
        assert not image[max(0,938-y):,:,3].any(), 'Shield edge leaked into mace attachment'
        assert image[936-y,1149-x,3] == 0, 'Shield top-edge sliver leaked into mace attachment'
assert not (ownership['mace'] & ownership['shield']).any(), 'Mace and shield own the same source pixels'
print('WARDEN_PARTS_PIXELS_OK: 20 isolated RGBA attachments, exact owned source pixels and reference/image hashes')
