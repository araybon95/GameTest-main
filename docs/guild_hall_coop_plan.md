# Customizable guild hall and co-op lobbies

Design proposal; multiplayer and the guild hall are not implemented yet.

The guild hall would become the place where players create or join a session, choose heroes, prepare together, and launch an expedition. Keep the existing solo settlement and saves working throughout development.

## Connection direction: standalone and Steam

The intended release is Steam, with standalone desktop support as well. Recommend one canonical lobby/relay service for both builds, with Steam integration providing identity, friends invitations, and Join Game discovery. Steam invitations resolve to the same underlying session as standalone invite codes; Steam and standalone clients should be able to enter the same hall. This cross-build interoperability is a recommended assumption, not a separately confirmed requirement.

Use the shared service for session admission, short-lived invite resolution, and relayed peer traffic. The host still resolves gameplay; the service does not have to run the full Godot simulation. The Steam build can publish the canonical session reference in a Steam lobby and respond to accepted invitations, while standalone clients join through the game's own invite flow. Private-session admission must be validated by the service rather than trusting a copied session ID.

This avoids two separate hall implementations. Steam-only peer networking can be an optional later transport optimization; it is not assumed to connect players who lack a Steam session. A relay is still required for the recommended shared internet joining path. Internet session hosting and Steam invitations need a selected service/deployment, service credentials, a Steamworks App ID, and a compatible Godot Steam integration. LAN/local-process testing can proceed before those are available.

## Recommended first version

- One host and up to two guests, matching the current three-hero party. Each player controls an assigned hero; the host controls unclaimed slots when fewer than three people join.
- A host-owned hall saved between sessions. Guests see its appearance and can inspect stations; only the host edits its layout initially.
- A guild name, banner emblem/colors, lighting preset, furnishing slots, and trophy displays. Painted pieces should fit anchored positions in the room, so furniture, characters, and background mesh together. Start with fixed slots rather than arbitrary dragging.
- A gathering table for hero assignment, expedition selection, and readiness. Changing the roster, expedition, or gameplay loadout clears readiness. Decorative changes need not clear it.
- Private sessions first. Joining requires an invite; public listings and permanent guild membership can follow later.

A persistent guild shared across accounts, with officers, pooled resources, and a hall accessible while its owner is offline, is a larger service feature. The first host-owned hall avoids requiring that infrastructure immediately.

## Existing foundations and gaps

`scenes/hub/settlement.gd` provides the existing settlement entry point. `scripts/game_data.gd` holds the three-hero party and already exposes participant-based route voting through `navigation_voters` and `authorize_move`. Combat uses shared party turns in `scenes/combat/combatscene.gd`.

State and saved journeys are currently local. There is no existing lobby transport, player identity system, remote hero ownership, reconnect flow, or authoritative network command layer. A lobby alone would not make expeditions or combat playable online.

## Ten implementation milestones

1. **Define the shared connection contract.** Target standalone desktop plus Steam, with one canonical lobby/relay service and Steam friends/invitation integration. Select the service and identity/admission model. Direct LAN connections can support development tests, but do not provide internet invite codes or solve NAT traversal by themselves.
2. **Build the hall scene.** Add a settlement entry, a readable painted interior, three gathering positions, and an expedition table. Preserve solo navigation. This milestone is local and is not advertised as online play.
3. **Add customization and persistence.** Store the host's guild name, banner choices, lighting, furniture slots, and trophies in a versioned hall profile separate from expedition saves. Unknown or missing cosmetic IDs fall back safely.
4. **Introduce the session model.** Track session ID, host, participant identities, hero ownership, selected expedition, readiness, and state revision independently of UI nodes. Put Steam/relay/LAN connection details behind a transport interface.
5. **Connect hosting and joining.** Implement private session creation, invitation/joining, roster updates, full-session rejection, build/protocol compatibility, connection timeouts, and clear leave behavior. Use the selected transport's real invitations or invite codes.
6. **Synchronize the hall.** The host validates cosmetic edits and sends the authoritative hall state. Guests receive the current snapshot when joining, including subsequent updates. Readiness and ownership cannot be changed on another player's behalf.
7. **Launch one synchronized expedition.** Validate readiness and unique hero assignments, then distribute the authoritative starting snapshot. Reuse the existing route-voting rules with actual participants. Hallway animation stays local; the host commits room entry once.
8. **Connect shared-turn combat.** Guests submit owned-hero actions; the host validates and serializes them, resolves gameplay and randomness once, and broadcasts results. Reject stale, duplicate, unauthorized, or invalid actions, including conflicting uses of shared items and turn-ending requests.
9. **Handle saves, departures, and reconnects.** Initially the host owns the session checkpoint. Guest client views must not overwrite personal solo progression through the existing autosave path. Define reward ownership before enabling persistent guest rewards. Reserve a disconnected hero briefly and resynchronize on reconnect; host departure ends the session cleanly until host migration is deliberately implemented.
10. **Test real co-op and polish.** Run separate game processes and machines through joins, changes, readiness, launch, combat, inventory/camp actions, return to hall, packet delay, dropped connections, and incompatible versions. Verify solo saves and RNG remain correct. Then review readability, hall cosmetics, and invitation UX.

## Authority and acceptance criteria

The host owns gameplay state, RNG, shared resources, expedition checkpoints, and accepted action ordering. Clients request actions and display host-approved state; they do not independently roll rewards or resolve fights. Revisions and command IDs prevent old requests from applying twice. Host authority is sufficient for a private co-op prototype; persistent competitive/shared guild economies would need stronger service-side validation.

The first **online hall** milestone is complete when three separate processes can join a session, see the same host-customized room and roster, choose distinct heroes, and ready/unready with consistent results. It does not claim online combat is complete. The first **playable co-op** milestone requires a synchronized expedition and encounter, consistent rewards/checkpoint ownership, and a clean return to the hall after disconnect or completion.

The platform direction is standalone desktop plus Steam. Selecting and configuring the common service, obtaining Steamworks access/App ID, and defining guest progression/rewards remain open implementation decisions. The visual hall/profile work can proceed independently of those integrations.
