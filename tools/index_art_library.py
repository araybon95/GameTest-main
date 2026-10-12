"""Index live artwork, dimensions, resource regions and replacement paths.

Reads source bytes and text only; never changes image pixels. Run from any cwd.
"""
from pathlib import Path
import html
import json
import re
import struct
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
LIBRARY = ROOT / "assets/art_library"


def dimensions(path):
    if path.suffix == ".png":
        data = path.read_bytes()
        return list(struct.unpack(">II", data[16:24]))
    if path.suffix == ".svg":
        element = ET.parse(path).getroot()
        view = element.attrib.get("viewBox", "0 0 128 128").split()
        result = []
        for attribute, fallback in [("width", view[2]), ("height", view[3])]:
            numeric = re.fullmatch(r"([\d.]+)(?:px)?", element.attrib.get(attribute, ""))
            result.append(float(numeric.group(1)) if numeric else float(fallback))
        return result
    return None


def build():
    references = {}
    for directory in ["scripts", "scenes", "tests", "assets"]:
        for path in (ROOT / directory).rglob("*"):
            if path.suffix not in [".gd", ".tscn", ".tres"]:
                continue
            for resource in re.findall(r'res://assets/art_library/[^"\s]+', path.read_text()):
                references.setdefault(resource, set()).add(str(path.relative_to(ROOT)))
    records = []
    for path in sorted(LIBRARY.rglob("*")):
        if path.suffix not in [".png", ".svg", ".tres"]:
            continue
        relative = path.relative_to(LIBRARY).as_posix()
        resource = "res://assets/art_library/" + relative
        record = {"file": relative, "resource": resource, "dimensions": dimensions(path),
                  "references": sorted(references.get(resource, []))}
        if path.suffix == ".tres":
            content = path.read_text()
            atlas = re.search(r'path="(res://assets/art_library/[^\"]+\.png)"', content)
            region = re.search(r'region = Rect2\(([^)]+)\)', content)
            if atlas and region:
                record["atlas"] = atlas[1].replace("res://assets/art_library/", "")
                record["region"] = [float(value.strip()) for value in region[1].split(",")]
                record["dimensions"] = record["region"][2:]
        if path.parent.name in ["items", "camp", "skills"]:
            record["individual_png_override"] = str(path.with_suffix(".png").relative_to(LIBRARY))
        records.append(record)
    (LIBRARY / "manifest.json").write_text(json.dumps({
        "schema": 1,
        "note": "Live source bank includes current art and retained variants/fallbacks. References are literal references, not an exhaustive runtime reachability claim.",
        "assets": records}, indent=2) + "\n")
    cards = []
    for record in records:
        image = record.get("atlas", record["file"])
        if "region" in record:
            x, y, w, h = record["region"]
            aw, ah = dimensions(LIBRARY / image)
            scale = min(112 / w, 112 / h)
            preview = f'<div class="tile" style="width:{w*scale}px;height:{h*scale}px;background-image:url(\'{html.escape(image)}\');background-size:{aw*scale}px {ah*scale}px;background-position:-{x*scale}px -{y*scale}px"></div>'
        else:
            preview = f'<img loading="lazy" src="{html.escape(image)}" alt="">'
        size = " × ".join(str(int(v)) for v in record["dimensions"] or [])
        override = record.get("individual_png_override", record["file"])
        cards.append(f'<article data-name="{html.escape(record["file"])}"><div class="preview">{preview}</div><a href="{html.escape(image)}">{html.escape(record["file"])}</a><p>{size}</p><small>Replace: {html.escape(override)}</small></article>')
    document = '''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Ashen live art library</title><style>
body{background:#101012;color:#ede1ce;font:16px system-ui;margin:24px}h1{font-family:Georgia,serif}p,small{color:#b5a694}a{color:#d1b884;overflow-wrap:anywhere}input{padding:12px;width:min(600px,90%);background:#211e1c;border:1px solid #665b4e;color:#ede1ce;font:inherit}main{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:16px;margin-top:24px}article{background:#191718;padding:16px;border:1px solid #51473e;border-radius:3px}.preview{height:120px;display:flex;justify-content:center;align-items:center;background:#0b0b0e;margin-bottom:12px}img{max-width:100%;max-height:112px;object-fit:contain}.tile{background-repeat:no-repeat}small{display:block;overflow-wrap:anywhere}
</style><h1>Ashen live art library</h1><p>Canonical artwork used by the game, with retained variants and fallback sources. See README.md for individual PNG replacements, transparency and sprite-sheet requirements.</p><input aria-label="Filter artwork by filename" placeholder="Search: healing_potion, merchant, workshop, camp…"><main>CARDS</main><script>document.querySelector('input').oninput=e=>{let q=e.target.value.toLowerCase();for(let card of document.querySelectorAll('article'))card.hidden=!card.dataset.name.toLowerCase().includes(q)};</script></html>'''
    (LIBRARY / "catalog.html").write_text(document.replace("CARDS", "\n".join(cards)))
    print(f"Indexed {len(records)} artwork images/resources; manifest.json and searchable catalog.html updated")


if __name__ == "__main__":
    build()
