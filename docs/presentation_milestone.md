# Combat and expedition presentation milestone

10 October 2026. This pass develops Ashen's own inked creature art and presentation around the existing shared-party RPG mechanics.

## Delivered roadmap

| Step | Result |
| --- | --- |
| Remaining enemy artwork | Seventeen independently replaceable creature sheets, covering the keep, Path congregation, moth infestation, villagers and bone rabble. Eight ordinary sheets have three poses; nine boss sheets have four, for 60 measured poses. Previous art is preserved. |
| Memorable bosses | Bosses have larger stage allocations than normal enemies, smaller support creatures in separate slots, heavier attack timing, a roar or ritual introduction, lore and phase markers. Coterie's replacement forms remain one encounter. |
| Attack camera | The attacker and target receive a spotlight and modest scenery zoom/shake while other actors are dimmed. The HUD stays fixed and the backdrop restores after the action. |
| Weapon and spell effects | Melee trails, bow projectiles, shields, healing, fire, frost, poison and lightning effects travel between the active actors. Giant chains and the Howling Head's teeth have creature-specific treatments. |
| Hallway exploration | Moving foreground detail, footsteps routed through the Effects bus, planted walking actors, safe standing-art fallbacks and encounter arrival fades. |
| Themed entrances | Illustrated palisade, keep, ribbed ritual and medical doorways introduce the next space; descent prompts explain the next floor and remain reopenable after staying. |
| Combat feedback | Damage, healing, status application/resistance, harmful ticks, misses and fully blocked impacts have distinct feedback. Enemy stress, guard and self-healing actions now receive presentation too. Numbers wait for queued impacts. |
| Camp and event presentation | Resting heroes sit around a single fire with contact shadows, names, classes and themed lore. Event investigators stand beside outlined clickable curios; room/corridor context and provision choices stay readable. |
| Progression audit | One hundred seeds per released three-floor dungeon were sampled. Route, camp, XP, equipment, boss and economy findings are recorded without speculative global balance changes. Two correctness fixes restore all scrolls to loot selection and apply equipped curse costs at each status tick. |
| Complete-run regression | The automated lifecycle covers preparation, three-floor navigation, camps, shops, rescue, boss phases, rewards, exact save/RNG restoration, victory, retreat and memorial records. It uses controlled lethal damage and does not establish ordinary-player difficulty. |

## User corrections

The Last Honorable Son's sword pose was replaced to correct its limbs, two-handed grip and attack facing. Phase replacements update the foot pivot immediately to avoid momentary floating during the existing breathing animation.

Creature classes are **Human** for bandits, **Corrupted** for keep revenants and supernatural monsters, **The Remade** for the Path congregation, and **Insect** for moths and their cocoons. Discovered bestiary pages and combat information show the type; existing undead, faction and boss traits retain their gameplay meanings.

## Verification and review

Godot 4.7.2 is used for import, headless smoke tests and graphical scene captures. Tests use separate application-data directories to protect player saves. Atlas checks inspect all recorded regions and imported alpha to catch overlap, missing body parts, inter-pose fragments and incorrect resource routing. Visual review includes the nine boss stages, attack/reveal poses, camps, events and four themed thresholds.

All 35 existing smoke scripts passed as a suite. The additional enemy-action integration test passed independently, bringing this project's checks to 36. The final graphical runs captured 36 boss frames and 13 exploration frames without runtime or render errors; the camp party cards were enlarged slightly so their Stress line stays inside the border.

The complete automated run and numeric audit are explained in [run_progression_audit.md](run_progression_audit.md). Human playtesting remains the appropriate check for difficulty, pacing and the feel of a sustained expedition.

Generated creature prompts, corrective prompts, source hashes and frame regions are recorded in [creature_art_provenance.json](creature_art_provenance.json). Door artwork provenance is in [thresholds_PROVENANCE.md](../assets/generated/thresholds_PROVENANCE.md).
