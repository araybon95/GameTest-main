# Combat readability

The default game window is now 1920 by 1080, matching the existing 1920 by 1080 design viewport. Canvas scaling remains enabled for resized windows.

Ability cards show the ability name and AP cost, illustration, full effect description, and cooldown directly on the card. Description text uses the same ivory color and 17-pixel size as the header. Cards are 170 pixels tall with space for six abilities in the left grid. Tooltips remain available. Checks cover all four classes at maximum upgrade level, including wrapped descriptions and headers.

Combat artwork was being darkened by multiplying the texture twice in the status shader. The fragment COLOR already includes the sampled texture. Using it directly restores the original artwork brightness for all hero/enemy models and the selected portrait while retaining burn, bleed, poison, chill and hurt feedback. Source images are preserved.

The RPG and status visual smoke checks pass. The full 1920 by 1080 combat layout was rendered and visually checked.
