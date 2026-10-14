# Graveyard and merchant orb visual update

The graveyard and merchant orb now use original generated artwork that matches the game's dark ink contours, chipped stone, worn iron and restrained bright accents. The active PNG assets in `assets/art_library/generated/` are `graveyard_ink_background.png` and `merchant_orb_ink.png`. The obsolete standalone cemetery marker has been removed; settlement hover now samples the painted town vista. The complete production prompt set and viewed style references are recorded in [the art provenance manifest](graveyard_orb_art_provenance.json).

The graveyard opens onto a painted cemetery vista with a charcoal memorial ledger, iron corner fittings and warm ivory names. Class, dungeon, floor, date, final trial and deeds remain visible in scrollable records. Long names wrap; empty records retain the unwritten-stones message. The settlement uses the matching painted cemetery cluster at its existing location.

The orb event uses cracked blue glass, corroded iron claws and a rough stone pedestal. The prop retains its aspect ratio and rests on the same floor as the heroes, with restrained cyan ambient light. Mouse hover follows the artwork's alpha silhouette; keyboard focus and native Button activation remain available. The event panel uses the same iron fittings and parchment colors as the rest of the game.

The combat gate, merchant route, trading rules and saved hero/memorial data are unaffected by the visual update. The existing orb event preview now checks the painted silhouette at three dungeon themes and captures both idle and hover states. The graveyard check covers single, empty and long-record views, scrolling and settlement navigation. Game controls and save behavior remain documented in the existing gameplay and settings guides.

Validation passed the graveyard, merchant orb event, camp/merchant, merchant trading and settlement music smoke checks. Twelve in-game screenshots were inspected across the graveyard and the orb's three dungeon themes. The settlement music check still reports its existing resource cleanup warnings at shutdown; its music routing assertions passed.
