# Hero proportions preview

[Combat after](combat-after.png) · [Before / after](before-after.png) · [Crusader and Occultist](combat-crusader-occultist.png) · [All five heroes](all-five-heroes.png)

Combat and standing exploration share one body-build profile. Visible image
bounds remove atlas padding; staff and bow tips are excluded from approximate
body-height measurements. Every hero keeps their feet on the ground line.

| Hero | Body height | Width relative to its natural aspect ratio |
| --- | --- | --- |
| Warden and Crusader | +8% | +10% |
| Ranger | −5% | −10% |
| Healer and Occultist | Baseline | −10% |

The original Ranger idle artwork has a narrower ready stance and less of a
wide-legged crouch. Attack/cast frames remain the existing art, with the same
class-width profile. Alternate and relic Ranger costume drawings retain their
existing stance while receiving the shared slimmer dimensions. Warden outfit
selection and armor variants retain their existing artwork and metadata.

Proportions persist during action poses and defeat poses. Class stats, hit
resolution, weapon selection and ability rules are unchanged. These previews
show real Godot scene renders; the five-hero lineup uses the same standing
helper as the dungeon map/entrance. Combat parties still contain three heroes.

This feature branch is for visual review before weapon-appearance work.

Validation: all 91 smoke checks pass, including planted feet during breathing,
repeated battlefield placement, attack-width consistency, five standing builds,
unchanged stats, saved combat colors and restoration of status effects after
returning to original colors. All 570 live art resources load. Native Godot
combat and lineup stills were inspected; independent code review found no
remaining Important or Critical issues. Some legacy headless scenes retain
non-blocking font/resource-cleanup diagnostics.
