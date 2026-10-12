# Hero voices and memories

Each living hero has a persistent cosmetic journal with one of two class-specific voices. Voices provide camp dialogue and companion farewells; they add no stats, quirks or penalties and consume no gameplay RNG. A survivor retains the journal across expeditions. A fallen life is archived in the graveyard; the next recruit in that class starts a fresh journal and alternates voice.

Memories are recorded from actual hooks: a successful heal for another hero, recovery from Death's Door, a party ward, surviving a floor guardian and opening the Crusader's coffin. Repeated identical memories are deduplicated; the journal retains its most recent twelve entries. Healing and warding create cosmetic mutual bonds. Death chooses a living companion with the strongest recorded bond, with party order resolving ties. It snapshots the personality, memories, speaker name and farewell into the memorial, then removes relationships to that fallen identity.

The hero sheet's scrollable Lore section includes disposition and biography. Camp's left text panel contains a personal line or remembrance of a loss from the current run. Combat logs the companion farewell and shows a brief reaction above that survivor. The graveyard includes personal memories and the original farewell below its existing factual death record. Old memorials and save files remain readable without the new fields.

Journals are included in save slots/checkpoints and settlement progression. `hero_stories_smoke.gd` exercises real combat healing and death, deduplicated records, closest-companion selection, immutable memorial snapshots, save/load, survivor continuity and a replacement's fresh identity. Existing graveyard, saves, leveling, Crusader rescue, camp and combat checks cover integration.
