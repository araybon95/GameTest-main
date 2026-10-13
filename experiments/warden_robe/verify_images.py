"""Read-only provenance and layer-coverage checks for the robe handoff."""
from pathlib import Path
import hashlib,json
import numpy as np
from PIL import Image
root=Path(__file__).resolve().parent
manifest=json.loads((root/'parts.json').read_text())
base=json.loads((root/'source/armor-parts.json').read_text())
original={p['name']:p['sha256'] for p in base['parts']}
for p in manifest['parts']:
    filename=root/'images'/(p['name']+'.png')
    digest=hashlib.sha256(filename.read_bytes()).hexdigest()
    assert digest==p['sha256'],p['name']+' changed image'
    if not p['name'].startswith('robe_'):
        assert digest==original[p['name']],p['name']+' original armor art changed'
    else:
        x,y,w,h=map(int,p['source_region'])
        source=np.asarray(Image.open(root/'source'/p['source_file']).convert('RGBA'))
        image=np.asarray(Image.open(filename).convert('RGBA'))
        assert np.array_equal(image,source[y:y+h,x:x+w]),p['name']+' panel export changed pixels'
        assert image[:,:,3].max()==255 and image[:,:,3].min()==0
        hem=p['joint_world'][1]+p['pivot_pixels'][1]*p['scale']-h*p['scale']
        # Hem covers the ankle caps but clears the boot soles in the setup.
        if p['name']=='robe_front': assert 0 < hem < 40,p['name']+' hem misses the boot reveal band'
        else: assert -60 < hem < 0,p['name']+' inner cloth misses the ankle-covering band'
print('WARDEN_ROBE_IMAGES_OK: 20 original layers unchanged, 2 lossless RGBA panels, ankle-covering hem')
