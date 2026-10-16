# Item readability, Unique gear and consumables

Inventory icons have bright rarity borders with glow, larger portraits and increased brightness. Each SVG can still be replaced independently with an identically named PNG. Common is green, Rare blue, Epic violet, Unique rose and Legendary gold.

Repeated copies of the same named consumable share one inventory entry, with the quantity visible on its icon. Scrolls remain single-use and have their independent 15% bonus drop chance. Healing Potion restores 20 HP, Cleansing Potion removes timed debuffs, and Solace Potion removes 15 Stress. Potions cost 1 AP in combat and can also be clicked in a living hero's map inventory. They cannot resurrect dead heroes. Merchants sell them; cleared combat/treasure/boss rooms have an independent 20% potion bonus roll.

Equipment rarity rates: Common 57%, Rare 25%, Epic 10%, Unique 3%, Legendary 5%. Bosses still guarantee a Legendary for an active party class. Merchants never sell Legendary gear.

Six Unique items: universal Venom Heart (trinket) and Winter Shard (charm), Warden's Vigil of Winter, Ranger's Adder's Requiem, Occultist's Septic Covenant and Healer's Cold Benediction. Each supplies a 30% Poison or Chill proc on a damaging skill hit. Equipped sources combine into one roll per effect per hit, capped at 50%. Misses, fully blocked hits, lethal hits and boss form transitions do not inflict procs. Scrolls do not trigger equipment procs.

Unique procs add at most three stacks and refresh a two-turn duration. Poison deals 2/4/6 damage per turn. Chill reduces attack damage by 25/35/45%, with diminishing returns. Ordinary status application refreshes without adding stacks. Existing resistance rules still apply to heroes.

Validation: items_unique_smoke.gd exercises consumable quantities, potion healing/cleansing/AP/dead-hero guard, class restrictions, actual combat procs and stack caps. Existing loot, combat, trinket, camp, event, corridor, beast, status visual and RPG checks also pass.
