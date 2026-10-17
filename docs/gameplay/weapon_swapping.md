# Visible class weapons

Use the hero sheet’s Inventory tab outside combat to preview and equip a class weapon. The comparison shows the current and proposed weapon before confirmation. Removing a weapon leaves the starter weapon visible, with no starter equipment bonus.

| Hero | Weapon family | Off-hand compatibility |
| --- | --- | --- |
| Warden | One-handed melee | Retains shield artwork |
| Ranger | Bows | Two-handed |
| Witch Hunter | Two-handed hammers | Requires empty off-hand |
| Occultist | Staves | Current one-handed staves retain grimoire compatibility; explicitly two-handed future staves require empty off-hand |

Weapon swaps retain the chosen armor, colors, character proportions and grounded feet. Named and transformed copies reuse their base weapon geometry while keeping their history and effects. Turning equipment appearances off retains the chosen cosmetic artwork and keeps equipped stats active.

Old saves that selected a relic outfit through a legendary weapon retain that outfit through a validated migration field. New weapon-only swaps do not select a different armor set. Witch Hunter’s internal `crusader`, `pc_*` and legacy weapon IDs remain stable; their visible weapons are hammers.

The shared compositor reads registered body, weapon and foreground-hand layers from `assets/art_library/weapons/`. It caches by class, outfit, base weapon and pose. The runtime cache is least-recently-used and sized for a full party (every pose, the ten-frame Warden walk and its execution) plus previews; layer composites are kept only briefly. Body/sole registration is independent of weapon size. Standing, travel, camp, full portraits, equipment previews and combat use the same selection. Bust portraits retain their existing head-only art.

Loading a save never fails because of equipment rules: gear that no longer fits its hero (wrong class or family, or an off-hand beside a two-handed weapon) returns to the pack, and unknown item IDs are removed. The weapon is checked before the other slots.

Warden’s integrated execution snapshots the selected weapon and outfit when queued. Ranger and Witch Hunter executions remain fixed-outfit **experimental studies**, now accepting all four class weapons through their preview exporters. Their victim reactions, embedded arrows, cleaver, camera and timing remain unchanged. Occultist has no execution.

See [sources, coverage and visual review](../../experimental/weapon_swapping/README.md). Builders retain original artwork and require explicit registration; missing combinations fail coverage checks rather than substituting another weapon.

## Rebuild and verify

Run the Godot reference/asset builders under `experimental/weapon_swapping/` sequentially. Run `prepare_study_assets.gd` after the ordinary class builders. After native visual review, run `python3 experimental/weapon_swapping/promote_assets.py`, then import the project. Production manifests contain only final referenced layers; source/cleanup sheets remain experimental.

```sh
python3 -m unittest discover -s tests/ci -v
godot --headless --editor --path . --import --quit
python3 tools/run_smoke_tests.py --output artifacts/class-weapons-full
```

Tests cover family/handedness rules, migration, named copies, conservation, no equip/load healing, previews/cache refresh, complete pose coverage, study identity and Warden execution snapshots. Native contact sheets and captures remain necessary for anatomy, grip and impact review.
