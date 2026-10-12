# Equipment feedback and balance playtest

Weapon-equipped damaging skills now carry a presentation-only signature: frost blades leave cyan cuts and shards; venom weapons leave green projectile trails and motes; draining weapons use crimson marks; healing/holy weapons use candle-gold flecks. Consecrated and corrupted ordinary weapons receive matching signatures. Weapon effects remain separate from scroll elements and creature attacks.

The signature is captured with each queued attack. Misses and fully blocked blows suppress elemental impact marks; projectile trails remain a weapon identity, not a successful poison/chill notification. These visuals change no damage, accuracy, statuses, turn costs, drops or RNG calls. Existing status applications still decide whether a debuff lands.

Hovering inventory and merchant gear shows a concise comparison, accounting for Keen/Fortified and Workshop transformations. Selecting equipment in the shared character record opens **Equipment Comparison**, with current/proposed costume, signed gains/losses and scrollable effects/history. **Equip** commits the choice; **Keep Current** or Escape leaves it unchanged. Other-class items are disabled. Stat changes describe equipment bonuses; existing accuracy/proc caps still apply. Increasing maximum HP does not heal. Armour costume priority and the saved equipment-costume opt-out are respected.

## Actual-action automated playtest

Eight bounded runs were exercised across seven isolated game processes using `tests/ordinary_playthrough.gd`. The runner used ordinary combat skills, AP, enemy turns, objectives, camps, consumables, class-restricted loot, merchant purchases/sales and legal equipment changes. It granted no health, damage, gold or forced drops. Cinematic/travel waiting was skipped, and global/gameplay RNG seeds were fixed for reproducibility.

| Run | Route/party | Result | Fights | Gold remaining |
| --- | --- | --- | ---: | ---: |
| Old Road, seed 2026 | Cautious / Occultist | Completed 3 floors | 8 | 30 |
| Old Road, seed 20 | Cautious / Healer | Completed 3 floors | 8 | 39 |
| Old Road, seed 2026 | Direct / Occultist | Completed 3 floors | 8 | 30 |
| Old Road, seed 20 | Direct / Healer | Retreated after casualty, floor 2 | 4 | 19 |
| Path of the Beast, seed 2026 | Fresh / Occultist, objectives | Retreated after casualty, floor 2 | 6 | 37 |
| Path of the Beast, seed 20 | Fresh / Healer, objectives | Retreated after casualty, floor 2 | 4 | 5 |
| Campaign: Old Road, seed 2026 | Cautious / Occultist | Completed 3 floors | 8 | 30 |
| Campaign: Path of the Beast | Earned equipment and training carried forward | Completed 3 floors | 12 | 166 |

All processes completed without script errors. The campaign's second run retained earned gear, XP and gold and spent earned training points. Fresh runs reset inventory, equipment, upgrades, histories and cosmetic selections. Shop policy sold loose spare gear, bought missing common weapons, kept up to two healing potions and bought missing common armour when affordable.

**Decision:** retain current prices and combat stats. In this sample, Old Road survivors ended with 30–39 gold, below the 40/100/150 rare/epic/unique equipment prices. The experienced campaign ended with enough gold for a meaningful upgrade or two 75-gold transformations. The more demanding Beast dungeon required progression in these two seeds. This supports the intended difficulty gradient without proving global balance.

**Limits:** this is deterministic automated play, not a human usability or statistical win-rate study. Only two seeds and two party compositions were sampled; Crusader parties, every relic combination and late-game gold accumulation remain unmeasured. No numerical balance change was justified by this sample. Future balancing should expand seed/party coverage and test purchasing higher-tier sidegrades rather than merely accumulating gold.

The condensed outcomes, party health and shop transactions are saved in [balance_2026_10_11.json](balance_2026_10_11.json). Local detailed reports: `C:/GAME/Ashen/balance-playtest-2026-10-11/` (per-run reports and logs). Regression coverage: `equipment_feedback_smoke.gd`, existing combat FX/controls/economy/equipment/save tests and native 1920×1080/1280×720 previews.
