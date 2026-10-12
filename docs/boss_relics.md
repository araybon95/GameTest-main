# Boss trophies and favourite protection

Eight boss identities now drop distinctive legendary charms: the Ash Chieftain, Last Honorable Son, Undying Lord, Harrowed Giant, Coterie, Howling Head, Oleander and Exuvia. Each has original lore, an independently replaceable SVG icon and a modest bonus through the existing equipment rules. One randomly selected party class can wear each drop, preserving the guaranteed party-class legendary rule. These charms replace that boss's ordinary gear reward rather than adding a second legendary. Existing independent 15% scroll rolls remain intact.

Trophies are excluded from ordinary equipment rolls and merchant purchases. Every dropped copy uses the equipment history system and records the defeated boss. Naming, deeds and heirloom inheritance work as before.

The victory reveal displays the awarded trophy and offers favourite marking before continuing to a floor entrance. Rewards are already in the inventory; closing or revisiting the screen cannot award them again. Final bosses show their trophy without opening a descent prompt. The Coterie's intermediate stages do not award loot.

The encounter is marked cleared before the reveal, so a checkpoint made while marking a favourite resumes the completed room rather than replaying its guardian.

Right-click an owned item icon to mark or unmark it. Gold stars mark favourites, merchant sell buttons show **PROTECTED**, and the underlying sale API also rejects them. A normal stacked item marks the entire stack; individually recorded gear marks only that copy. Equipping and history promotion preserve protection. Optional `item_favourites` dictionaries persist in progression and save slots; older saves default to no favourites.

Original icons live under `assets/art_library/items/*_trophy.svg`. A same-name PNG can replace any one icon later through the existing per-item override mechanism.

Checks: `boss_relics_smoke.gd`, updated `floor_entrance_smoke.gd`, existing equipment, economy, loot, save and UI smoke checks. Visual previews use isolated user data.
