# Settings, saved journeys and settlement polish

Open Settings from the top-right button or **F10**. Master, Music and Effects sliders include mute at zero. Brightness ranges from 65% to 140%; settings apply immediately and persist between launches.

Three manual save slots and a separate automatic checkpoint store party selection, health/stress/statuses, dungeon floors and position, cleared rooms, inventory, gold, equipment, upgrades, discoveries, unlocks, names, colors and loot RNG state. Saves are available in the settlement and on the dungeon map after an encounter is resolved. Combat and event decisions are not saved midway. Loading asks before replacing the current journey. Continue on the title screen opens the checkpoint. Saves are local Godot `user://saves/*.cfg` files, not stored in the repository.

Automatic checkpoints refresh after reaching a safe map state, before travel into danger, after entering settlement screens, and periodically while safe. An interrupted encounter resumes from the preceding safe checkpoint.

The unlocked Workshop offers **Name & Colors**. Names are limited to 20 characters; an empty name restores the class name. Combat cards display the chosen name with the class underneath. Original, red, green, blue and gold are simple accent recolors: Warden/Crusader/Healer red accents, Ranger green accents, and Occultist purple accents. These are sprite color masks, not new armor models or textures. Choices are cosmetic and free.

The settlement Graveyard records each fallen hero once per journey. Memorials show the name and class at death, dungeon/floor, last damaging creature or status, battles survived, damage dealt and health recovered. Memorial history survives loading an older journey; reloading the same journey cannot duplicate the same hero's memorial. It does not introduce permanent loss of that class from the roster. The graveyard marker is original Ashen SVG artwork.

The Chapel Archive now contains a volume for each dungeon, navigable contents and creature plates. Encountered creatures reveal art, expanded lore and base stat notes; longer lore scrolls within the page. Future dungeons have unwritten volumes. Narrative additions are in `scripts/world_lore.gd`.

Dungeon travel can cross multiple cleared rooms in one click. Routes never cross an unresolved encounter on the way to another room. Future multi-participant navigation retains adjacent-room voting. Returning to cleared rooms updates the travel message rather than repeating old loot messages.

Settlement music keeps the same player and playback position through buildings and preparation; it stops on embark or return to title. Sword, bow, spell and fully blocked impact sounds are original short synthesized WAVs, individually replaceable in `assets/audio/combat/`. Healing/control magic and restorative scrolls now also play spell audio.

Validation: 21 smoke scripts cover existing expeditions plus settings/save roundtrips, safe routes, customization gates, naming, graveyard persistence and audio behavior. New settings, Workshop, book, named combat, title and memorial screens were rendered and visually checked at 1920×1080. These checks do not replace longer playtesting for balance.
