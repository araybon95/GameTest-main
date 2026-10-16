"""Assemble ten reference documents from current artwork; do not paint new art."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import hashlib
import io
import json
import re
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
IMAGES = HERE / "images"
PACK = HERE / "makko-reference-pack.zip"
FRAME_PACK = ROOT / "experimental/art_review/01-current-frames.zip"
SCREENSHOT = ROOT / "review-output/2026-10-16-art-repairs/integrated/warden_transitions/095.png"
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
INK = "#17171b"
PAPER = "#ede1ce"
REFERENCE_BACKGROUND = "#303039"
records = []
pixel_checks = []


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source(path):
    return {"path": str(path.relative_to(ROOT)), "sha256": sha(path)}


def font(size):
    return ImageFont.truetype(FONT, size)


def record(path, role, sources, tiles=None):
    with Image.open(path) as image:
        image.verify()
    with Image.open(path) as image:
        dimensions = list(image.size)
    assert max(dimensions) <= 2048
    records.append({"file": "images/" + path.name, "role": role,
                    "dimensions": dimensions, "bytes": path.stat().st_size,
                    "sha256": sha(path), "sources": sources, "tiles": tiles or []})


def grid(filename, title, subtitle, tiles, columns, sources):
    """Display full RGBA tiles at native scale on a clean reference background."""
    width = max(tile["image"].width for tile in tiles)
    height = max(tile["image"].height for tile in tiles)
    cell_w, cell_h = width + 32, height + 58
    rows = (len(tiles) + columns - 1) // columns
    sheet = Image.new("RGBA", (cell_w * columns, 78 + cell_h * rows), REFERENCE_BACKGROUND)
    draw = ImageDraw.Draw(sheet)
    draw.rectangle((0, 0, sheet.width, 68), fill=INK)
    draw.text((16, 8), title, fill=PAPER, font=font(25))
    draw.text((16, 42), subtitle, fill="#b5a694", font=font(15))
    mapped = []
    for i, tile in enumerate(tiles):
        image = tile["image"]
        x = (i % columns) * cell_w + (cell_w - image.width) // 2
        y = 78 + (i // columns) * cell_h + 16 + height - image.height
        # Composite only for the reference document. Hidden RGB in zero-alpha
        # source pixels must not appear when an image service drops alpha.
        sheet.alpha_composite(image, (x, y))
        expected = Image.new("RGBA", image.size, REFERENCE_BACKGROUND)
        expected.alpha_composite(image)
        assert sheet.crop((x, y, x + image.width, y + image.height)).tobytes() == expected.tobytes()
        label_y = 78 + (i // columns) * cell_h + height + 22
        draw.rectangle(((i % columns) * cell_w + 8, label_y,
                        (i % columns + 1) * cell_w - 8, label_y + 28), fill=INK)
        draw.text(((i % columns) * cell_w + 16, label_y + 3), tile["label"],
                  fill=PAPER, font=font(16 if len(tile["label"]) < 28 else 13))
        mapped.append({"label": tile["label"], "sheet_xywh": [x, y, image.width, image.height],
                       **tile["provenance"]})
    target = IMAGES / filename
    sheet.save(target)
    # Confirm PNG encoding also retains every source tile, including alpha.
    with Image.open(target) as decoded:
        for tile, position in zip(tiles, mapped):
            x, y, w, h = position["sheet_xywh"]
            expected = Image.new("RGBA", (w, h), REFERENCE_BACKGROUND)
            expected.alpha_composite(tile["image"])
            assert decoded.crop((x, y, x + w, y + h)).tobytes() == expected.tobytes()
    pixel_checks.append({"file": filename, "native_tiles_checked": len(tiles),
                         "reference_composite_exact": True, "background": REFERENCE_BACKGROUND,
                         "source_art_repainting": "none", "art_resampling": "none"})
    record(target, title, sources, mapped)


def main():
    IMAGES.mkdir(parents=True, exist_ok=True)
    approved = ROOT / "experimental/witch_hunter/concept.png"
    target = IMAGES / "01-witch-hunter-approved-character.png"
    original = Image.open(approved).convert("RGBA")
    reference = Image.new("RGBA", original.size, PAPER)
    reference.alpha_composite(original)
    reference.save(target)
    record(target, "Approved Witch Hunter character identity and material detail", [source(approved)])

    with zipfile.ZipFile(FRAME_PACK) as archive:
        index = json.loads(archive.read("01-current-frames/frame-index.json"))
        assert index["snapshot"] == "2026-10-16 local repair working tree; not published"
        frames = index["frames"]
        families = [("02-warden-current-poses.png", "default-warden", "WARDEN / CURRENT COMBAT POSES"),
                    ("03-witch-hunter-current-poses.png", "default-crusader", "WITCH HUNTER / CURRENT COMBAT POSES"),
                    ("04-ranger-current-poses.png", "default-ranger", "RANGER / CURRENT COMBAT POSES"),
                    ("05-occultist-current-poses.png", "default-occultist", "OCCULTIST / CURRENT COMBAT POSES"),
                    ("06-hooded-raider-current-poses.png", "hooded-raider", "HOODED ASH RAIDER / CURRENT VARIANT")]
        for filename, family, title in families:
            tiles, sources = [], {}
            states = ["frame-%02d" % i for i in range(12)] if family == "hooded-raider" else ["idle", "windup", "attack", "guard", "hurt", "death"]
            for state in states:
                frame = next(f for f in frames if f["family"] == family and f["state"] == state)
                for path, expected in frame["source_hashes"].items():
                    assert sha(ROOT / path) == expected, "Regenerate current frame pack: " + path
                    sources[path] = {"path": path, "sha256": expected}
                member = "01-current-frames/" + frame["native_file"]
                data = archive.read(member)
                assert hashlib.sha256(data).hexdigest() == frame["native_sha256"]
                image = Image.open(io.BytesIO(data)).convert("RGBA")
                tiles.append({"label": state.upper(), "image": image,
                              "provenance": {"frame_id": frame["id"], "frame_pack_member": member,
                                             "frame_sha256": frame["native_sha256"],
                                             "registered_origin_offset": frame["canvas_origin_offset"]}})
            grid(filename, title, "Native registered sprites / read left to right / annotations are not part of the artwork",
                 tiles, 4 if family == "hooded-raider" else 2, list(sources.values()))

    # The legacy Penitent row is deliberately omitted from this style reference.
    skill_path = ROOT / "assets/art_library/skills/painted_skills.png"
    atlas = Image.open(skill_path).convert("RGBA")
    skill_ids = ["wd_slash", "wd_guard", "wd_bash", "wd_heavy", "wd_rally",
                 "rg_quick", "rg_volley", "rg_pierce", "rg_mark", "rg_dodge",
                 "oc_hex", "oc_drain", "oc_blast", "oc_veil", "oc_weak",
                 "hl_mend", "hl_blessing", "hl_smite", "hl_turn", "hl_ward"]
    tiles = []
    for ident in skill_ids:
        resource = ROOT / ("assets/art_library/skills/" + ident + ".tres")
        x, y, w, h = map(int, re.search(r"region = Rect2\((\d+), (\d+), (\d+), (\d+)\)", resource.read_text()).groups())
        tiles.append({"label": ident, "image": atlas.crop((x, y, x + w, y + h)),
                      "provenance": {"source_rect_xywh": [x, y, w, h], "resource": str(resource.relative_to(ROOT))}})
    grid("07-ui-painted-ability-icons.png", "UI / PAINTED ABILITY ICONS", "20 current atlas samples / visual treatment only / legacy Penitent axe row excluded",
         tiles, 5, [source(skill_path)])

    layout = json.loads((ROOT / "assets/art_library/items/sheets/layout.json").read_text())
    # Keep complete source sheets together. Some original painted shapes cross
    # a nominal tile edge; shuffling individual cells would orphan those pixels.
    loot = Image.new("RGBA", (1536, 2048), REFERENCE_BACKGROUND)
    sources, mapped = [], []
    for page, sheet_number in enumerate([1, 4]):
        path = ROOT / ("assets/art_library/items/sheets/ink_loot_%02d.png" % sheet_number)
        image = Image.open(path).convert("RGBA")
        assert image.size == (1536, 1024)
        loot.alpha_composite(image, (0, page * 1024))
        expected = Image.new("RGBA", image.size, REFERENCE_BACKGROUND)
        expected.alpha_composite(image)
        assert loot.crop((0, page * 1024, 1536, (page + 1) * 1024)).tobytes() == expected.tobytes()
        sources.append(source(path))
        for tile in range(24):
            number = (sheet_number - 1) * 24 + tile
            x, y = tile % 6 * 256, tile // 6 * 256
            mapped.append({"item_id": layout[number]["id"], "label": layout[number]["name"],
                           "source": str(path.relative_to(ROOT)), "source_rect_xywh": [x, y, 256, 256],
                           "sheet_xywh": [x, y + page * 1024, 256, 256]})
    target = IMAGES / "08-ui-items-equipment-and-rituals.png"
    loot.save(target)
    with Image.open(target) as decoded:
        assert decoded.tobytes() == loot.tobytes()
    pixel_checks.append({"file": target.name, "full_native_source_sheets_checked": 2,
                         "reference_composite_exact": True, "art_resampling": "none",
                         "original_cell_arrangement_preserved": True})
    record(target, "UI / 48 ITEM, EQUIPMENT & RITUAL ICONS", sources, mapped)

    # An annotated reference document, not a newly painted or runtime-ready atlas.
    board = Image.new("RGBA", (1536, 1024), "#303039")
    draw = ImageDraw.Draw(board)
    draw.rectangle((0, 0, 1536, 80), fill=INK)
    draw.text((24, 14), "UI / CURRENT HUD FRAMES, BANNER & STATUS", font=font(29), fill=PAPER)
    draw.text((24, 52), "Reference layout only / labels, background and palette swatches are annotations", font=font(17), fill="#b5a694")
    ui = ROOT / "assets/art_library/presentation/ui"
    placements = [("panel_frame.png", (0, 0, 668, 360), (40, 140), "PANEL BORDER / native 668 x 360"),
                  ("map_backing.png", (20, 20, 630, 320), (810, 140), "MAP BACKING / native 630 x 320"),
                  ("attack_banner.png", (0, 0, 629, 99), (450, 580), "ATTACK BANNER / native 629 x 99")]
    sources, mapped = [], []
    for name, rect, position, label in placements:
        path = ui / name
        image = Image.open(path).convert("RGBA").crop(rect)
        board.alpha_composite(image, position)
        draw.text((position[0], position[1] - 30), label, font=font(19), fill=PAPER)
        sources.append(source(path))
        mapped.append({"source": str(path.relative_to(ROOT)), "source_rect_xywh": [rect[0], rect[1], image.width, image.height],
                       "sheet_xywh": [*position, image.width, image.height], "display_scale": 1})
    for i, state in enumerate(["bleed", "burn", "poison"]):
        path = ui / ("status_" + state + ".png")
        image = Image.open(path).convert("RGBA")
        x = 80 + i * 220
        draw.text((x, 750), state.upper(), font=font(21), fill=PAPER)
        board.alpha_composite(image, (x, 800))
        board.alpha_composite(image.resize((96, 96), Image.Resampling.NEAREST), (x + 48, 790))
        sources.append(source(path))
        mapped.append({"source": str(path.relative_to(ROOT)), "native_display_xy": [x, 800], "detail_xy": [x + 48, 790], "detail_scale": 4, "detail_resampling": "nearest"})
    draw.text((80, 900), "Native 24px + 4x detail", font=font(18), fill="#b5a694")
    palette = ["#101012", "#ede1ce", "#b5a694", "#b89c71", "#665b4e"]
    for i, color in enumerate(palette):
        x = 900 + i * 115
        draw.rectangle((x, 790, x + 90, 850), fill=color)
        draw.text((x, 864), color, font=font(15), fill=PAPER)
    draw.text((900, 750), "CURRENT UI TOKENS", font=font(21), fill=PAPER)
    sources.append(source(ROOT / "scripts/ui_skin.gd"))
    target = IMAGES / "09-ui-frames-banner-and-status.png"
    board.save(target)
    record(target, "Current HUD components and UI palette", sources, mapped)

    target = IMAGES / "10-current-gameplay-and-ui-context.png"
    shutil.copyfile(SCREENSHOT, target)
    assert sha(target) == sha(SCREENSHOT)
    record(target, "Current gameplay composition, scene scale, HUD and palette", [source(SCREENSHOT)])

    assert len(records) == 10
    assert len(list(IMAGES.glob("*.png"))) == 10
    manifest = {"date": "2026-10-16", "image_count": 10,
                "base_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
                "snapshot": "current local artwork including the verified 13-finding repair pass",
                "reference_frame_pack_sha256": sha(FRAME_PACK), "images": records,
                "pixel_checks": pixel_checks,
                "notes": ["Existing artwork only; no new generative artwork or source edits.",
                          "Native character and icon tiles are composited unchanged at 1:1 scale onto a neutral reference background; exact expected output pixels are checked.",
                          "The approved Witch Hunter concept is composited at 1:1 scale onto parchment white for an opaque reference document.",
                          "HUD board composites native assets onto a labeled neutral reference background; status detail uses 4x nearest-neighbor.",
                          "Sheet labels and arrangement are reference annotations, not a runtime atlas specification.",
                          "UI ability/item imagery is a style reference; character sheets define actual equipped weapons."]}
    (HERE / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    (HERE / "SHA256SUMS.txt").write_text("".join(r["sha256"] + "  " + r["file"] + "\n" for r in records))
    with zipfile.ZipFile(PACK, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
        for path in sorted(IMAGES.glob("*.png")):
            archive.write(path, path.relative_to(HERE))
        for name in ["README.md", "MAKKO-PROMPT.txt", "manifest.json", "SHA256SUMS.txt"]:
            archive.write(HERE / name, name)
    with zipfile.ZipFile(PACK) as archive:
        assert archive.testzip() is None
        assert len([p for p in archive.namelist() if p.lower().endswith((".png", ".jpg", ".jpeg", ".webp"))]) == 10
    print("PASS: ten reference PNGs, exact native-scale reference composites, source hashes and ZIP CRC")
    print("Download: " + str(PACK))
    print("ZIP bytes: " + str(PACK.stat().st_size))


if __name__ == "__main__":
    main()
