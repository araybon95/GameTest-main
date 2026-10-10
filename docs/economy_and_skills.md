# Equipment economy, merchant orbs and skill inspection

## Equipment prices and inventory sales

Equipment now has these gold values. Merchants continue to exclude legendary items from purchases.

| Tier | Buy value | Sale value |
| --- | ---: | ---: |
| Common | 8 | 2 |
| Rare | 40 | 10 |
| Epic | 100 | 25 |
| Unique | 150 | 37 |
| Legendary | 200, loot only | 50 |

Potions, scrolls and provisions keep their existing explicit prices. A Healing Potion still costs 8 gold, Trail Rations 2 and Cleansing Herbs 3. Sales return 25% of value, rounded down; the 2–3 gold provisions have zero sale value and cannot be sold. Lock Tools cost 4 and sell for 1. There is no minimum-one-gold exception.

`GameData.item_sell_price(id)` returns a catalog item's sale value. `GameData.sell_item(id)` sells exactly one unequipped inventory copy and returns whether the transaction succeeded. It accepts unwanted items from other classes and legendary loot. Equipped copies have already been removed from inventory, so an equipped item is protected even if another loose copy is sold. Unknown items, absent or nonpositive counts, and nonpositive sale values reject without mutation.

Accepted purchases and sales save checkpoint slot 0, including money, inventory and equipment. Both operations restore their previous in-memory state if checkpoint writing fails; purchase rollback also restores journey bookkeeping. `purchase_scroll` uses the same purchase transaction. Selling does not grant XP, deeds, expedition progress or rewards, change HP, move the party or edit the map.

The three free departure rations are a separate `journey.rations` counter, not inventory objects. They cannot be sold. Bought Trail Rations remain inventory supplies and are used only after that counter runs out. Repeated departure cannot convert free rations into gold through the sale API. Every available purchase-to-sale round trip loses gold; crafting does not increase an item's rarity sale value.

`tests/economy_smoke.gd` checks the entire equipment price table and all explicit supply prices, stacks, equipped-only rejection and loose duplicates, other-class and legendary sales, legendary purchase rejection, insufficient funds, checkpoint continuity, rollback on a blocked save path, no buy/sell profit, and preservation of map/hero/progression state. `tests/camp_merchant_smoke.gd` now explicitly expects a 40-gold Sentinel Shield. The earlier balance report and captured results remain historical evidence for their recorded revisions.

A bounded automated ordinary-mechanics check (`ordinary_playthrough.gd -- 20 occultist cautious`) completed Old Road's three floors with eight victories and five camp visits, using a fresh Warden/Ranger/Occultist party and earned gold. The floor-two merchant visit purchased two common weapons for 8 gold each and exercised the new orb → shop → orb → map route. The party finished with 33 gold; all three survivors reached level 3, with the Warden at 0 HP on Death's Door. This policy did not sell items or buy higher-tier gear, so it checks the continued viability of its existing common-equipment preparation, not the long-term rate of gold accumulation. Supply prices are independently covered by the catalog assertions. This is automation, not a human playtest. An earlier attempt during unfinished orb imports/harness edits produced runtime errors and was excluded. The successful run had no script/assertion/resource-loader errors; it retained the previously observed shutdown warning for two ObjectDB instances and one retained resource.

## Emporium interface

Buy and Sell tabs retain the All, Weapons, Armor, Trinkets, Relics and Consumables filters. Sort by rarity, name or value. Sale rows show the inventory stack and the gold paid for one copy. Gold, quantity and transaction feedback refresh after each click; exhausted rows disappear, and the catalog keeps its scroll position. Empty categories explain that equipped copies must first be unequipped. The settlement Apothecary remains a remedies-only shop.

`tests/merchant_trade_smoke.gd` covers the tabs, filters, sorting, stack transactions, protected equipment, empty states, scroll preservation, shop returns and Apothecary restrictions. Seven 1920 × 1080 captures from `tests/merchant_trade_preview.gd` were inspected for readability and layout.

## Merchant orb room event

There is one merchant orb per floor in an ordinary combat room. Combat has no merchant button. After victory, the continue action reads **Inspect Merchant Orb** and opens `merchant_orb_room.tscn` with the floor's bandit, keep or Remade backdrop and lore. Click the outlined blue orb to enter the Emporium. **Return Through Orb** brings the party back to this event; **Continue Exploring** returns to the same map location. The map's Inspect Merchant Orb action allows subsequent visits.

The event and entry handler both require a cleared merchant room. Repeated visits grant no rewards, do not resolve a random event and do not restore or change hero health, status, XP or position. The painted pedestal is an independent asset at `assets/generated/merchant_orb_ink.png`; see [the graveyard and orb visual update](graveyard_orb_visuals.md).

Manual and automatic saves are available in the cleared orb event and its merchant. Loading a saved journey returns to the dungeon map with the room still cleared and the orb available. Buy/sell checkpoints include the current transaction; save data does not need to retain a transient shop scene.

`tests/merchant_orb_event_smoke.gd` checks combat gating, the victory continuation, clickable prop, shop returns and repeat visits, state preservation and save continuity. The camp/merchant and full-run harnesses now use the event route. Bandit, keep and Remade hover captures from `tests/merchant_orb_event_preview.gd` were inspected at 1920 × 1080.

## Combat skill inspection

Available skills use olive backgrounds and gold frames, with a brighter border on hover or focus. Unavailable skills use charcoal/red backgrounds and a readable reason badge. An immediate inspection card above the hovered skill shows its current effects, hero name/class, AP cost/current AP, remaining cooldown and usable/target ranks. Damage previews include the current equipment, training, target traits and Mark before Block. The popup ignores mouse input and stays inside the viewport.

Unavailable actions remain native disabled buttons. A separate keyboard focus target lets players inspect their details with Tab without activating them. Reasons distinguish battle completion, a slain hero, cooldown, insufficient AP, hero position, target range and the Crusader's health cost. Inspection does not spend resources; the existing combat resolution checks still enforce activation.

`tests/skill_hover_smoke.gd` uses actual pointer and keyboard input to verify ready and disabled inspections, all eligibility reasons, shared inline/popup values, viewport bounds, input transparency and activation limits. Seven captures from `tests/skill_hover_preview.gd` were inspected for clipping and readability.

## Integrated verification

All 47 automated smoke suites passed after integration, including the full expedition milestone flow, settings/saves, merchant transactions and skill input checks. Godot imported the new SVG and scripts successfully; the local Ziva editor plugin retained its pre-existing Safe save warning during editor startup. Runtime smoke and preview checks had no script or loader errors. Visual QA covered seven merchant screens, seven skill inspections and three themed orb events. The ordinary run above provides a bounded gameplay check; longer-term economy balance remains a playtesting decision.
