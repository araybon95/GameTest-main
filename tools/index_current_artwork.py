"""Index artwork in the current checkout without ignored local audit outputs."""
from pathlib import Path
import hashlib
import json
import subprocess
from collections import Counter

ROOT = Path(__file__).resolve().parents[1]
ART_TYPES = {'.png', '.jpg', '.jpeg', '.webp', '.svg', '.gif', '.mp4', '.ora', '.kra',
             '.psd', '.psb', '.ase', '.aseprite', '.xcf', '.blend', '.tiff', '.tif',
             '.bmp', '.avif', '.exr', '.hdr', '.ico', '.obj', '.fbx', '.gltf', '.glb',
             '.otf', '.ttf'}


def main():
    result = subprocess.run(['git', 'ls-files', '-z', '--cached', '--others', '--exclude-standard'],
                            cwd=ROOT, check=True, capture_output=True)
    paths = sorted({p.decode() for p in result.stdout.split(b'\0') if p})
    entries = []
    for name in paths:
        path = ROOT / name
        if path.suffix.lower() not in ART_TYPES or not path.is_file():
            continue
        entries.append({'path': name, 'bytes': path.stat().st_size,
                        'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
    manifest = {
        'repository': 'araybon95/GameTest-main',
        'snapshot': 'current branch contents; per-file hashes identify the exact artwork',
        'artwork_file_count': len(entries),
        'artwork_types': dict(sorted(Counter(Path(x['path']).suffix.lower() for x in entries).items())),
        'files': entries,
        'notes': ['Includes current sources, selectable variants, retained studies and editing exports.',
                  'ZIP containers, engine import caches and ignored local audit outputs are excluded.',
                  'An inventory is not a complete visual-consistency certification.'],
    }
    target = ROOT / 'ARTWORK-MANIFEST.json'
    target.write_text(json.dumps(manifest, indent=2) + '\n')
    print(f'Indexed {len(entries)} current artwork files in {target.name}')


if __name__ == '__main__':
    main()
