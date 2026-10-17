"""Copy only referenced final layers into the runtime art library.

Run after the Godot builders and visual approval. Source references/cleanup sheets
remain experimental, and rebuilding does not mutate retained original artwork.
"""
from pathlib import Path
import re
import shutil

ROOT = Path(__file__).resolve().parents[2]
for hero in ('warden', 'ranger', 'crusader', 'occultist'):
    source = ROOT / 'experimental/weapon_swapping' / hero
    target = ROOT / 'assets/art_library/weapons' / hero
    target.mkdir(parents=True, exist_ok=True)
    text = (source / 'frames.gd').read_text()
    paths = set(re.findall(r'res://experimental/weapon_swapping/'+hero+r'/assets/[^"\n]+\.png', text))
    for path in paths:
        relative = Path(path.removeprefix('res://'))
        shutil.copy2(ROOT / relative, target / relative.name)
    text = text.replace('res://experimental/weapon_swapping/'+hero+'/assets/', 'res://assets/art_library/weapons/'+hero+'/')
    (target / 'frames.gd').write_text(text)
    print(f'{hero}: promoted {len(paths)} referenced layers')
