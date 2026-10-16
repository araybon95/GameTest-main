# Ashen Expedition

A grimdark, side-view party RPG built in Godot. Assemble three heroes in the Hamlet, explore multi-floor dungeons, resolve illustrated encounters and fight with shared party turns.

[Current documentation](docs/README.md) · [Artwork and downloads](ARTWORK-DOWNLOADS.md) · [Current design previews](experimental/README.md) · [Latest gameplay audit](docs/gameplay_stability_audit.md)

## Run the game

1. Import `project.godot` in Godot and allow artwork imports to finish.
2. Press **F5**, enter the Hamlet and choose three heroes in the Barracks.
3. Embark from the expedition board or gate.

The project declares Godot 4.7 with GL Compatibility rendering. The verified development runtime is **Godot 4.6.3**.

## Current game

- Expeditions open at a painted entrance. Open the map and click a reachable room; unknown discoveries offer illustrated choices with saved outcomes.
- Heroes share a party turn, with individual AP, skill cooldowns, equipment, formation and persistent expedition wounds/stress.
- The default Witch Hunter uses the approved hooded armor, two-handed hammer and physical skills with ritual support. **Binding Sigil applies Weakness**. Internal `crusader` identifiers preserve save compatibility.
- The original-outfit Warden has an integrated final-Ash-Raider execution. Witch Hunter and Ranger execution studies remain experimental.
- Combat uses a dedicated ground layer and shared foot anchors; scenery moves independently. Outfits, equipment appearances and the optional manual-walking mode remain supported.
- Settings, saved journeys, progression, rewards and memorials are implemented. Online lobby transport remains future work.

## Controls

| Context | Controls |
| --- | --- |
| Map | Click a reachable room; Scout, Inventory or Retreat |
| Story event | Select an investigator, choose an option, then Continue |
| Combat | Select a hero; **1–5** selects a skill; **Enter** uses it; **Tab** opens inventory |
| Hero details | Right-click a hero or press **C**; **Q / E** cycles heroes |
| Help/settings | **I** opens contextual controls; **F10** opens settings |
| Optional manual walking | **D / Right**, **A / Left**, **W / Enter**; **Space** toggles automatic walking |

## Artwork

Use [Artwork and downloads](ARTWORK-DOWNLOADS.md) for current production sources, the 160-frame review pack, ten-image Makko references and layered Witch Hunter files for Krita. Production resources and selectable variants are retained even when an older cell is not used by the default outfit.

## Verification

[Automated regression checks](docs/automated_checks.md) run on pushes and pull requests, with downloadable logs and per-test results.

The latest full regression run passed **101 smoke scripts**, including 30 malformed-save cases. Two additional automated Old Road expeditions exercised actual actions and earned equipment. Engine/shutdown diagnostics remain documented; this is not a leak-free or human-balance certification. See the [audit report](docs/gameplay_stability_audit.md).

Run an individual check with:

```sh
godot --headless --audio-driver Dummy --path . --script res://tests/save_runtime_validation_smoke.gd
```

Use separate application-data directories for tests so player saves are preserved.

## License

Original project code uses the [MIT License](LICENSE). Retained third-party artwork keeps its own credits and terms beside the assets, including [item credits](assets/art_library/items/CREDITS.md). Asset provenance files are retained.
