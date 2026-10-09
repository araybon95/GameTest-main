extends Control
## Ashen Expedition — shared-turn party combat with selectable abilities,
## independent enemy targets, timed effects, equipment and universal scrolls.
## Party composition comes from the Barracks; encounter rosters from the dungeon.

# Shared game data/state, preloaded by path (no global class registry needed).
const GameState := preload("res://scripts/game_data.gd")
const Rules = preload("res://scripts/encounter_rules.gd")
const StatusVisual = preload("res://scenes/combat/status_visual.gd")
var enemies: Array[Dictionary] = []
var enemy_views: Array[Button] = []
var selected_enemy_index: int = 0
var acting_enemy_index: int = 0

const GOLD = "#8F4546"
const IVORY = "#EADDD0"
const MUTED = "#B5A2A3"
const RED = "#DF7870"
const VIRTUE_COLOR = "#8FB07A"
const AFFLICTION_COLOR = "#C25A55"

const CARD_ART_DIR = "res://assets/generated/"
const DEFAULT_ENEMY_NAME: String = "Hollow Villager"
const DEFAULT_ENEMY_MAX_HP: int = 68
const DEFAULT_ENEMY_ATTACK: int = 7
const DEFAULT_ENEMY_ART: String = "res://assets/generated/enemy_hollow_villager.png"
const HUB_SCENE = "res://scenes/hub/settlement.tscn"

## Allow F6 preview of the combat layout with the default Old Road encounter.
const REQUIRE_EXPEDITION := false

const AFFLICTIONS: Array[String] = ["Paranoid", "Masochistic", "Abusive", "Irrational", "Hopeless", "Fearful"]
const VIRTUES: Array[String] = ["Stalwart", "Courageous", "Focused", "Powerful", "Vigorous", "Vigilant"]
const VIRTUE_CHANCE = 0.25

var party: Array = []
var hero_state: Dictionary = {}
var hero_buttons: Dictionary = {}
var hero_portraits: Dictionary = {}
var hero_name_labels: Dictionary = {}
var hero_stat_labels: Dictionary = {}
var hero_health_bars: Dictionary = {}
var hero_stress_bars: Dictionary = {}
var selected_hero: String = ""

var expedition_title: String = "The Old Road"
var enemy_name: String = DEFAULT_ENEMY_NAME
var enemy_max_hp: int = DEFAULT_ENEMY_MAX_HP
var enemy_attack_base: int = DEFAULT_ENEMY_ATTACK
var enemy_art_path: String = DEFAULT_ENEMY_ART
var enemy_undead: bool = false
var enemy_hp: int = DEFAULT_ENEMY_MAX_HP
var enemy_block: int = 0
var enemy_mark_bonus: int = 0
var enemy_weak_rounds: int = 0
var round_number: int = 1
var battle_over: bool = false
var reward_given: bool = false
var battle_log: Array[String] = []

var round_label: Label
var hand_title: Label
var hand_container: Control
var log_container: VBoxContainer
var end_turn_button: Button
var enemy_label: Label
var enemy_intent_label: Label
var enemy_art: TextureRect
var gold_label: Label
var merchant_orb: Button
var selected_info: Label
var selected_portrait: TextureRect
var scroll_container: HBoxContainer


func _ready() -> void:
	if REQUIRE_EXPEDITION and GameState.selected_expedition.is_empty():
		get_tree().call_deferred("change_scene_to_file", HUB_SCENE)
		return
	_apply_expedition()
	_build_interface()
	_start_battle()


func _apply_expedition() -> void:
	var expedition: Dictionary = GameState.selected_expedition
	expedition_title = str(expedition.get("name", "The Old Road"))
	var depth: int = GameState.floor_index if GameState.run_active else 0
	var room: Dictionary = GameState.floors[depth][GameState.room_position] if GameState.run_active else {}
	var ids: Array = room.get("enemies", [room.get("creature", expedition.get("creature", "hollow_villager"))])
	enemies.clear()
	var boss: bool = room.get("kind", "") == "boss"
	for creature_id in ids.slice(0, 1 if boss else 3):
		enemies.append(Rules.make_enemy(GameState.creature(str(creature_id)), str(creature_id), depth, boss))
		GameState.discover_creature(str(creature_id))
	if boss and room.has("support_creature"):
		var support_id: String = str(room["support_creature"])
		enemies.append(Rules.make_enemy(GameState.creature(support_id), support_id, depth, false, true))
		GameState.discover_creature(support_id)
	if room.has("boss_phases"):
		enemies[0]["phase_creatures"] = room["boss_phases"]
		enemies[0]["phase_index"] = 0
	selected_enemy_index = 0
	_load_enemy(0)


func _store_enemy() -> void:
	if enemies.is_empty():
		return
	var enemy: Dictionary = enemies[selected_enemy_index]
	enemy["hp"] = enemy_hp
	enemy["block"] = enemy_block
	enemy["mark"] = enemy_mark_bonus
	enemy["weak"] = enemy_weak_rounds


func _load_enemy(index: int) -> void:
	selected_enemy_index = index
	var enemy: Dictionary = enemies[index]
	enemy_name = str(enemy["name"])
	enemy_hp = int(enemy["hp"])
	enemy_max_hp = int(enemy["max_hp"])
	enemy_attack_base = int(enemy["attack"])
	enemy_block = int(enemy["block"])
	enemy_mark_bonus = int(enemy["mark"])
	enemy_weak_rounds = int(enemy["weak"])
	enemy_undead = bool(enemy["undead"])
	enemy_art_path = str(enemy["art"])
	if index < enemy_views.size():
		enemy_art = enemy_views[index].get_node("EnemyArt")


func _living_enemies() -> Array[int]:
	_store_enemy()
	var living: Array[int] = []
	for index in range(enemies.size()):
		if int(enemies[index]["hp"]) > 0:
			living.append(index)
	return living


func _select_enemy(index: int) -> void:
	if battle_over or index < 0 or index >= enemies.size() or int(enemies[index]["hp"]) <= 0:
		return
	_store_enemy()
	_load_enemy(index)
	_refresh_all()



func _advance_boss_phase(index: int) -> bool:
	var entry: Dictionary = enemies[index]
	var phases: Array = entry.get("phase_creatures", [])
	var next: int = int(entry.get("phase_index", 0)) + 1
	if int(entry["hp"]) > 0 or next >= phases.size():
		return false
	var id: String = str(phases[next])
	var replacement := Rules.make_enemy(GameState.creature(id), id, GameState.floor_index, true)
	replacement["phase_creatures"] = phases
	replacement["phase_index"] = next
	enemies[index] = replacement
	GameState.discover_creature(id)
	if index < enemy_views.size():
		enemy_views[index].get_node("EnemyArt").texture = _load_texture(str(replacement["art"]))
	_load_enemy(index)
	_add_log("THE COTERIE — Stage %d / %d: %s steps forward. The hymn continues." % [next + 1, phases.size(), replacement["name"]])
	return true

func _advance_dead_bosses() -> void:
	_store_enemy()
	var original: int = selected_enemy_index
	for index in range(enemies.size()):
		_advance_boss_phase(index)
	_load_enemy(original)

func _check_battle_over() -> void:
	_advance_dead_bosses()
	if _living_enemies().is_empty():
		battle_over = true
		_add_log("VICTORY — all enemies defeated.")
		_award_reward()
	elif _standing_heroes().is_empty():
		battle_over = true
		_add_log("DEFEAT — the party has fallen.")


func _start_battle() -> void:
	battle_over = false
	reward_given = false
	round_number = 1
	enemy_hp = enemy_max_hp
	enemy_block = 0
	enemy_mark_bonus = 0
	enemy_weak_rounds = 0
	battle_log.clear()
	hero_state.clear()

	for hero_id in party:
		var hero: Dictionary = GameState.hero(hero_id)
		var abilities: Array = GameState.hero_abilities(str(hero_id))
		var max_hp: int = GameState.hero_max_hp(str(hero_id))
		hero_state[hero_id] = {
			"name": str(hero.get("name", hero_id)),
			"hp": max_hp,
			"max_hp": max_hp,
			"block": 0,
			"ap": 2,
			"stress": 0,
			"abilities": abilities,
			"cooldowns": {},
			"statuses": {},
			"dead": false,
			"deaths_door": false,
			"damage_mod": 0,
			"stress_per_turn": 0,
			"resolved": false,
			"resolve_tag": "",
			"resolve_type": ""
		}
		if GameState.run_heroes.has(hero_id):
			for key in ["hp", "stress", "dead", "deaths_door", "damage_mod", "stress_per_turn", "resolved", "resolve_tag", "resolve_type"]:
				hero_state[hero_id][key] = GameState.run_heroes[hero_id][key]

	selected_hero = str(party[0]) if not party.is_empty() else ""
	var survivors: Array = _standing_heroes()
	if not survivors.is_empty():
		selected_hero = str(survivors[0])
	_add_log("%s — %d enemies block the path." % [expedition_title, enemies.size()])
	_add_log("%d heroes. %d ability sets. One party turn." % [party.size(), party.size()])
	_add_log("At 100 Stress a hero faces a resolve test — Virtue or Affliction.")
	_refresh_all()


# -------------------- PARTY STATE --------------------

func _name_of(hero_id: String) -> String:
	return str(hero_state.get(hero_id, {}).get("name", hero_id))


func _is_standing(hero_id: String) -> bool:
	return not bool(hero_state[hero_id]["dead"])


func _standing_heroes() -> Array:
	var out: Array = []
	for hero_id in party:
		if _is_standing(hero_id):
			out.append(hero_id)
	return out


func _select_hero(hero_id: String) -> void:
	if battle_over or not _is_standing(hero_id):
		return
	selected_hero = hero_id
	_refresh_all()


func _play_card(hero_id: String, card_index: int) -> void:
	if battle_over or hero_id != selected_hero:
		return
	var state: Dictionary = hero_state[hero_id]
	if not _is_standing(hero_id):
		return
	if card_index < 0 or card_index >= state["abilities"].size():
		return
	var card_id: String = str(state["abilities"][card_index])
	var card: Dictionary = GameState.card_stats(card_id)
	if int(state["ap"]) < int(card["cost"]):
		return

	state["ap"] = int(state["ap"]) - int(card["cost"])
	if int(state["cooldowns"].get(card_id, 0)) > 0:
		state["ap"] = int(state["ap"]) + int(card["cost"])
		return
	var cooldown: int = GameState.ability_cooldown(card_id)
	if cooldown > 0:
		state["cooldowns"][card_id] = cooldown + 1
	_add_log("%s uses %s." % [_name_of(hero_id), card["name"]])
	_resolve_card(hero_id, card)

	_check_battle_over()
	_refresh_all()


func _attack_damage(hero_id: String, card: Dictionary) -> int:
	var dmg: int = int(card.get("damage", 0)) + int(hero_state[hero_id]["damage_mod"])
	dmg += GameState.equipment_bonus(hero_id, "damage")
	if enemy_undead and card.has("undead_bonus"):
		dmg += int(card["undead_bonus"])
	return Rules.damage_after_chill(dmg, hero_state[hero_id]["statuses"])


func _resolve_card(hero_id: String, card: Dictionary) -> void:
	card = card.duplicate(true)
	if card.has("block"):
		card["block"] = int(card["block"]) + GameState.equipment_bonus(hero_id, "block")
	if card.has("heal"):
		card["heal"] = int(card["heal"]) + GameState.equipment_bonus(hero_id, "heal")
	match str(card["effect"]):
		"attack":
			_attack_with_equipment(hero_id, card)
		"pierce":
			_attack_with_equipment(hero_id, card, true)
		"block":
			_gain_block(hero_id, int(card["block"]))
		"attack_block":
			_attack_with_equipment(hero_id, card)
			_gain_block(hero_id, int(card["block"]))
		"team_block":
			for ally in _standing_heroes():
				_gain_block(ally, int(card["block"]))
		"heal":
			_heal_hero(hero_id, int(card["heal"]))
		"team_heal":
			for ally in _standing_heroes():
				_heal_hero(ally, int(card["heal"]))
		"stress_heal":
			for ally in _standing_heroes():
				_reduce_stress(ally, int(card["amount"]))
		"mark":
			enemy_mark_bonus += int(card["bonus"])
			_add_log("Enemy marked: next hit +%d." % enemy_mark_bonus)
		"weaken":
			enemy_weak_rounds = 2
			_add_log("Enemy weakened for 2 attacks.")
		"drain":
			_attack_with_equipment(hero_id, card)
			_heal_hero(hero_id, int(card["heal"]))
		"stress_attack":
			_attack_with_equipment(hero_id, card)
			_gain_stress(hero_id, int(card["stress"]))


func _attack_with_equipment(hero_id: String, card: Dictionary, ignore_block: bool = false) -> void:
	var target: int = selected_enemy_index
	var phase: int = int(enemies[target].get("phase_index", 0))
	var actual: int = _deal_enemy_damage(_attack_damage(hero_id, card), ignore_block)
	if actual <= 0:
		return
	var drained: int = int(floor(actual * GameState.equipment_bonus(hero_id, "life_drain") / 100.0))
	if drained > 0:
		_heal_hero(hero_id, drained)
	if int(enemies[target].get("phase_index", 0)) == phase and int(enemies[target]["hp"]) > 0 and randf() * 100 < GameState.equipment_bonus(hero_id, "poison_chance"):
		Rules.apply_status(enemies[target]["statuses"], "poison")
		_add_log("%s's weapon poisons %s." % [_name_of(hero_id), enemies[target]["name"]])


# -------------------- ENEMY --------------------

func _enemy_attack_power() -> int:
	var enemy: Dictionary = enemies[selected_enemy_index]
	var escalation: int = ((round_number - 1) % 3) * 2
	var base: int = int(round((int(enemy["normal_attack"]) + escalation) * 0.3)) if enemy["support"] else enemy_attack_base + escalation
	if enemy_weak_rounds > 0:
		base = maxi(0, base - 3)
	return Rules.damage_after_chill(base, enemy["statuses"])


func _enemy_target() -> String:
	var standing: Array = _standing_heroes()
	if standing.is_empty():
		return ""
	return str(standing[(round_number - 1 + selected_enemy_index) % standing.size()])


func _enemy_move(index: int) -> Dictionary:
	var enemy: Dictionary = enemies[index]
	if enemy["support"] and (round_number - 1) % 3 == 1:
		return {"name": "Cover Ally", "effect": "ally_guard"}
	var moves: Array = enemy["moves"]
	return moves[(round_number - 1 + index) % moves.size()]


func _enemy_action() -> void:
	_store_enemy()
	var original: int = selected_enemy_index
	for index in range(enemies.size()):
		if int(enemies[index]["hp"]) <= 0 or _standing_heroes().is_empty():
			continue
		_load_enemy(index)
		acting_enemy_index = index
		_tick_enemy_statuses(index)
		if enemy_hp <= 0:
			_store_enemy()
			continue
		var move: Dictionary = _enemy_move(index)
		if move.get("effect", "") == "lament":
			for hero_id in _standing_heroes():
				_gain_stress(hero_id, int(move.get("stress", 4)))
				if move.has("status"):
					Rules.apply_status(hero_state[hero_id]["statuses"], str(move["status"]))
			_add_log("%s intones %s: the party gains %d Stress." % [enemy_name, move["name"], int(move.get("stress", 4))])
		elif move.get("effect", "") == "remake":
			enemy_hp = mini(enemy_max_hp, enemy_hp + int(move.get("heal", 12)))
			_add_log("%s uses %s: restores %d HP." % [enemy_name, move["name"], int(move.get("heal", 12))])
		elif move.get("effect", "") == "ally_guard":
			var living: Array[int] = _living_enemies()
			var ally: int = living[0]
			var amount: int = maxi(1, enemy_attack_base)
			enemies[ally]["block"] = int(enemies[ally]["block"]) + amount
			if ally == index:
				enemy_block = int(enemies[ally]["block"])
			_add_log("%s covers %s: +%d Block." % [enemy_name, enemies[ally]["name"], amount])
		else:
			var damage: int = maxi(0, int(round(_enemy_attack_power() * float(move.get("scale", 1.0)))))
			for hit in range(int(move.get("hits", 1))):
				var target: String = _enemy_target()
				if target == "":
					break
				var actual: int = _apply_damage(target, damage)
				_add_log("%s uses %s on %s: %d damage." % [enemy_name, move["name"], _name_of(target), damage])
				if actual > 0 and not hero_state[target]["dead"] and move.has("status"):
					Rules.apply_status(hero_state[target]["statuses"], str(move["status"]), 0.3 if enemies[index]["support"] else 1.0)
					_add_log("%s suffers %s (2 turns)." % [_name_of(target), str(move["status"]).capitalize()])
				_gain_stress(target, 2)
				var reflected: int = int(floor(actual * GameState.equipment_bonus(target, "reflection") / 100.0))
				if reflected > 0:
					enemy_hp = maxi(0, enemy_hp - reflected)
					_hurt_portrait(enemy_art)
					_add_log("%s reflects %d damage to %s." % [_name_of(target), reflected, enemy_name])
					if enemy_hp <= 0:
						break
			if enemy_weak_rounds > 0:
				enemy_weak_rounds -= 1
		_advance_chill(enemies[index]["statuses"])
		_store_enemy()
	var living: Array[int] = _living_enemies()
	if not living.is_empty():
		_load_enemy(original if living.has(original) else living[0])


func _enemy_intent_text() -> String:
	if enemy_hp <= 0:
		return "SLAIN"
	if battle_over:
		return "Encounter finished"
	var move: Dictionary = _enemy_move(selected_enemy_index)
	if move.get("effect", "") == "lament":
		return "%s · Party +%d Stress%s" % [move["name"], int(move.get("stress", 4)), " · Chill" if move.has("status") else ""]
	if move.get("effect", "") == "remake":
		return "%s · Heal %d HP" % [move["name"], int(move.get("heal", 12))]
	if move.get("effect", "") == "ally_guard":
		return "Cover ally · +%d Block" % enemy_attack_base
	var target: String = _enemy_target()
	var damage: int = int(round(_enemy_attack_power() * float(move.get("scale", 1.0))))
	return "%s → %s\n%d × %d%s" % [move["name"], _name_of(target), damage, int(move.get("hits", 1)), " · " + str(move["status"]).capitalize() if move.has("status") else ""]


func _advance_chill(statuses: Dictionary) -> void:
	if statuses.has("chill"):
		statuses["chill"]["turns"] = int(statuses["chill"]["turns"]) - 1
		if int(statuses["chill"]["turns"]) <= 0:
			statuses.erase("chill")


func _tick_enemy_statuses(index: int) -> void:
	var statuses: Dictionary = enemies[index]["statuses"]
	for status_id in statuses.keys():
		if status_id == "chill" or enemy_hp <= 0:
			continue
		var effect: Dictionary = statuses[status_id]
		enemy_hp = maxi(0, enemy_hp - int(effect["damage"]))
		_hurt_portrait(enemy_art)
		_add_log("%s takes %d %s damage." % [enemy_name, int(effect["damage"]), status_id])
		effect["turns"] = int(effect["turns"]) - 1
		if int(effect["turns"]) <= 0:
			statuses.erase(status_id)


func _tick_hero_statuses(hero_id: String) -> void:
	var statuses: Dictionary = hero_state[hero_id]["statuses"]
	for status_id in statuses.keys():
		if status_id == "chill" or not _is_standing(hero_id):
			continue
		var effect: Dictionary = statuses[status_id]
		var damage: int = int(effect["damage"])
		if status_id == "poison":
			damage = maxi(0, int(ceil(damage * (1.0 - minf(100.0, GameState.equipment_bonus(hero_id, "poison_resist")) / 100.0))))
		_apply_damage(hero_id, damage, true)
		_add_log("%s takes %d %s damage." % [_name_of(hero_id), damage, status_id])
		effect["turns"] = int(effect["turns"]) - 1
		if int(effect["turns"]) <= 0:
			statuses.erase(status_id)


# -------------------- DAMAGE / HEAL / STRESS --------------------

func _deal_enemy_damage(amount: int, ignore_block: bool = false) -> int:
	var target_index: int = selected_enemy_index
	var hp_before: int = enemy_hp
	var total: int = amount + enemy_mark_bonus
	enemy_mark_bonus = 0
	var absorbed: int = 0
	if not ignore_block:
		absorbed = mini(total, enemy_block)
		enemy_block -= absorbed
	var damage: int = total - absorbed
	enemy_hp = maxi(0, enemy_hp - damage)
	_add_log("%s takes %d damage%s." % [enemy_name, damage, " (%d blocked)" % absorbed if absorbed > 0 else ""])
	if damage > 0:
		_hurt_portrait(enemy_art)
	_flash(enemy_art, Color("#E78A84"))
	_store_enemy()
	if enemy_hp <= 0 and not _advance_boss_phase(target_index):
		_add_log(enemy_name + " is slain.")
		var living: Array[int] = _living_enemies()
		if not living.is_empty():
			_load_enemy(living[0])
	return mini(hp_before, damage)


func _apply_damage(hero_id: String, amount: int, bypass_block: bool = false) -> int:
	var state: Dictionary = hero_state[hero_id]
	if bool(state["dead"]):
		return 0
	var absorbed: int = 0 if bypass_block else mini(amount, int(state["block"]))
	state["block"] = int(state["block"]) - absorbed
	var damage: int = amount - absorbed
	if damage <= 0:
		_add_log("%s blocks the blow." % _name_of(hero_id))
		_flash(hero_buttons[hero_id], Color("#C9C4B0"))
		return 0
	_hurt_portrait(hero_portraits[hero_id])
	if selected_hero == hero_id:
		_hurt_portrait(selected_portrait)
	_flash(hero_buttons[hero_id], Color("#E78A84"))
	if bool(state["deaths_door"]) or int(state["hp"]) <= 0:
		state["dead"] = true
		state["deaths_door"] = false
		_add_log("%s is slain at Death's Door!" % _name_of(hero_id))
		return damage
	var remaining: int = int(state["hp"]) - damage
	if remaining <= 0:
		state["hp"] = 0
		state["deaths_door"] = true
		_add_log("%s takes %d damage and stands at DEATH'S DOOR!" % [_name_of(hero_id), damage])
	else:
		state["hp"] = remaining
		_add_log("%s takes %d damage%s." % [_name_of(hero_id), damage, " (%d blocked)" % absorbed if absorbed > 0 else ""])
	return damage


func _heal_hero(hero_id: String, amount: int) -> void:
	var state: Dictionary = hero_state[hero_id]
	if bool(state["dead"]):
		return
	var before: int = int(state["hp"])
	state["hp"] = mini(int(state["max_hp"]), before + amount)
	if int(state["hp"]) > 0:
		state["deaths_door"] = false
	_add_log("%s heals %d HP." % [_name_of(hero_id), int(state["hp"]) - before])


func _gain_block(hero_id: String, amount: int) -> void:
	hero_state[hero_id]["block"] = int(hero_state[hero_id]["block"]) + amount
	_add_log("%s gains %d Block." % [_name_of(hero_id), amount])


func _gain_stress(hero_id: String, amount: int) -> void:
	var state: Dictionary = hero_state[hero_id]
	if bool(state["dead"]):
		return
	state["stress"] = mini(100, int(state["stress"]) + amount)
	if not bool(state["resolved"]) and int(state["stress"]) >= 100:
		_resolve_stress_test(hero_id)


func _reduce_stress(hero_id: String, amount: int) -> void:
	var state: Dictionary = hero_state[hero_id]
	if bool(state["dead"]):
		return
	var before: int = int(state["stress"])
	state["stress"] = maxi(0, before - amount)
	var eased: int = before - int(state["stress"])
	if eased > 0:
		_add_log("%s's Stress eases (-%d)." % [_name_of(hero_id), eased])


func _resolve_stress_test(hero_id: String) -> void:
	var state: Dictionary = hero_state[hero_id]
	state["resolved"] = true
	if randf() < VIRTUE_CHANCE:
		var virtue: String = VIRTUES[randi() % VIRTUES.size()]
		state["resolve_tag"] = virtue
		state["resolve_type"] = "virtue"
		state["damage_mod"] = int(state["damage_mod"]) + 2
		state["stress"] = 45
		_add_log("RESOLVE TEST — %s is VIRTUOUS (%s)!" % [_name_of(hero_id), virtue])
		_add_log("%s fights on: +2 damage, Stress steadied to 45." % _name_of(hero_id))
		_heal_hero(hero_id, 6)
	else:
		var affliction: String = AFFLICTIONS[randi() % AFFLICTIONS.size()]
		state["resolve_tag"] = affliction
		state["resolve_type"] = "affliction"
		state["damage_mod"] = int(state["damage_mod"]) - 2
		state["stress_per_turn"] = int(state["stress_per_turn"]) + 3
		state["stress"] = 100
		_add_log("RESOLVE TEST — %s is AFFLICTED (%s)!" % [_name_of(hero_id), affliction])
		_add_log("%s deals -2 damage and suffers +3 Stress each turn." % _name_of(hero_id))
	var tint: Color = Color(VIRTUE_COLOR) if state["resolve_type"] == "virtue" else Color(AFFLICTION_COLOR)
	_flash(hero_buttons[hero_id], tint)


# -------------------- TURN FLOW --------------------

func _end_turn() -> void:
	if battle_over:
		return
	# Chill lasts through two actions by its affected side.
	for hero_id in party:
		_advance_chill(hero_state[hero_id]["statuses"])
	_enemy_action()
	_check_battle_over()
	if battle_over:
		_refresh_all()
		return
	for hero_id in party:
		var state: Dictionary = hero_state[hero_id]
		_tick_hero_statuses(hero_id)
		state["block"] = 0
		if _is_standing(hero_id):
			var regenerated: int = GameState.equipment_bonus(hero_id, "regeneration")
			if regenerated > 0:
				_heal_hero(hero_id, regenerated)
			state["ap"] = 2
			_gain_stress(hero_id, int(state["stress_per_turn"]))
			for ability_id in state["cooldowns"]:
				state["cooldowns"][ability_id] = maxi(0, int(state["cooldowns"][ability_id]) - 1)
		else:
			state["ap"] = 0
	_check_battle_over()
	if not battle_over:
		round_number += 1
		if not _is_standing(selected_hero):
			selected_hero = str(_standing_heroes()[0])
		_add_log("Round %d begins." % round_number)
	_refresh_all()


# -------------------- VIEW REFRESH --------------------

func _refresh_all() -> void:
	round_label.text = "ROUND %d" % round_number
	gold_label.text = "GOLD  %d" % GameState.gold
	if is_instance_valid(merchant_orb):
		merchant_orb.disabled = not battle_over or not _living_enemies().is_empty()
		merchant_orb.text = "ENTER EMPORIUM" if not merchant_orb.disabled else "MERCHANT ORB · SEALED"
	if not hero_state.has(selected_hero):
		return
	var hero: Dictionary = hero_state[selected_hero]
	hand_title.text = "ABILITIES  ·  %d / 2 AP" % int(hero["ap"])
	selected_portrait.texture = _load_texture(str(GameState.hero(selected_hero).get("art", "")))
	_sync_portrait(selected_portrait, hero)
	selected_info.text = "%s\n\nHealth  %d / %d\nStress  %d / 100\nBlock  %d\nAction points  %d / 2\n%s" % [str(hero["name"]).to_upper(), int(hero["hp"]), int(hero["max_hp"]), int(hero["stress"]), int(hero["block"]), int(hero["ap"]), "DEATH'S DOOR" if hero["deaths_door"] else str(hero["resolve_tag"])]
	selected_info.text += "\n" + Rules.status_text(hero["statuses"])
	for hero_id in party:
		var state: Dictionary = hero_state[hero_id]
		var tag: String = ""
		if str(state["resolve_tag"]) != "":
			tag = "  [" + str(state["resolve_tag"]).to_upper() + "]"
		var name_label: Label = hero_name_labels[hero_id]
		name_label.text = ("▶ " if hero_id == selected_hero else "") + str(state["name"]).to_upper()
		name_label.tooltip_text = tag
		var portrait: TextureRect = hero_portraits[hero_id]
		portrait.modulate = Color(0.5, 0.5, 0.54, 0.8) if bool(state["dead"]) else Color.WHITE
		_sync_portrait(portrait, state)
		if bool(state["deaths_door"]):
			name_label.add_theme_color_override("font_color", Color(RED))
		elif state["resolve_type"] == "virtue":
			name_label.add_theme_color_override("font_color", Color(VIRTUE_COLOR))
		elif state["resolve_type"] == "affliction":
			name_label.add_theme_color_override("font_color", Color(AFFLICTION_COLOR))
		else:
			name_label.add_theme_color_override("font_color", Color(IVORY))

		var status: String = "AP %d/2  ·  Blk %d  ·  Stress %d" % [
			int(state["ap"]), int(state["block"]), int(state["stress"])
		]
		if bool(state["deaths_door"]):
			status = "DEATH'S DOOR  ·  one more blow ends them"
		elif bool(state["dead"]):
			status = "SLAIN"
		hero_stat_labels[hero_id].text = status
		hero_stat_labels[hero_id].tooltip_text = Rules.status_text(state["statuses"])
		(hero_buttons[hero_id].get_node("Effects") as Label).text = Rules.status_text(state["statuses"])

		var button: Button = hero_buttons[hero_id]
		var health: ProgressBar = hero_health_bars[hero_id]
		health.max_value = int(state["max_hp"])
		health.value = int(state["hp"])
		hero_stress_bars[hero_id].value = int(state["stress"])
		button.disabled = battle_over or not _is_standing(hero_id)
		button.modulate = Color(0.55, 0.55, 0.6) if bool(state["dead"]) else Color.WHITE
		_style_card_backing(button, Color("#291C23"), Color("#D3AF72") if hero_id == selected_hero else Color(GOLD))

	_refresh_enemies()
	end_turn_button.disabled = false
	end_turn_button.text = "END PARTY TURN" if not battle_over else ("CONTINUE EXPEDITION" if _living_enemies().is_empty() and GameState.run_active else "RETURN TO THE HAMLET")
	_refresh_hand()
	_refresh_scrolls()
	_refresh_log()


func _refresh_hand() -> void:
	for child in hand_container.get_children():
		hand_container.remove_child(child)
		child.queue_free()
	if not hero_state.has(selected_hero):
		return
	var hand: Array = hero_state[selected_hero]["abilities"]
	for index in range(hand.size()):
		var card_id: String = str(hand[index])
		var card: Dictionary = GameState.card_stats(card_id)
		var view: Button = _create_card_view(card_id, card)
		var cooldown: int = int(hero_state[selected_hero]["cooldowns"].get(card_id, 0))
		view.disabled = battle_over or not _is_standing(selected_hero) or cooldown > 0 or int(hero_state[selected_hero]["ap"]) < int(card["cost"])
		if cooldown > 0:
			(view.get_node("Contents/Effect") as Label).text = "READY IN %d TURN(S)" % cooldown
		view.pressed.connect(_play_card.bind(selected_hero, index))
		hand_container.add_child(view)
		var card_width: float = 220.0
		var card_position: Vector2 = Vector2((index % 2) * 234.0, (index / 2) * 178.0)
		view.position = card_position
		view.size = Vector2(card_width, 170.0)
		view.z_index = index
	if hand.is_empty():
		var empty_label: Label = _make_label("No abilities equipped.", 23, Color(MUTED))
		empty_label.position = Vector2(360.0, 150.0)
		hand_container.add_child(empty_label)


func _refresh_log() -> void:
	for child in log_container.get_children():
		log_container.remove_child(child)
		child.queue_free()
	var first: int = maxi(0, battle_log.size() - 10)
	for i in range(first, battle_log.size()):
		var label: Label = _make_label("• " + battle_log[i], 19, Color(MUTED))
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		log_container.add_child(label)


func _add_log(message: String) -> void:
	battle_log.append(message)


func _award_reward() -> void:
	if reward_given:
		return
	reward_given = true
	var reward := 2
	if not GameState.selected_expedition.is_empty():
		reward = int(GameState.selected_expedition.get("reward", 5)) if not GameState.run_active or GameState.current_room_kind() == "boss" else 2
	GameState.gold += reward
	_add_log("Spoils: +%d Gold (total %d)." % [reward, GameState.gold])
	for item_id in GameState.claim_room_loot():
		var item: Dictionary = GameState.Items.item(item_id)
		_add_log("Loot: %s [%s]." % [item["name"], str(item["rarity"]).to_upper()])


func _refresh_scrolls() -> void:
	for child in scroll_container.get_children():
		scroll_container.remove_child(child)
		child.queue_free()
	for item_id in GameState.Items.SCROLLS:
		var count: int = int(GameState.inventory.get(item_id, 0))
		if count <= 0:
			continue
		var item: Dictionary = GameState.Items.item(item_id)
		var button := Button.new()
		button.text = "%s ×%d\n1 AP · SINGLE USE" % [str(item["name"]).trim_suffix(" Scroll"), count]
		button.icon = _load_texture(GameState.Items.icon_path(str(item_id)))
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 32)
		button.custom_minimum_size = Vector2(235, 68)
		button.add_theme_font_size_override("font_size", 18)
		_style_card_backing(button, Color("#21171D"), Color(str(GameState.Items.RARITY_COLORS[item["rarity"]])))
		button.tooltip_text = GameState.Items.description(item_id)
		button.disabled = battle_over or not _is_standing(selected_hero) or int(hero_state[selected_hero]["ap"]) < 1
		button.pressed.connect(_use_scroll.bind(str(item_id)))
		scroll_container.add_child(button)
	if scroll_container.get_child_count() == 0:
		scroll_container.add_child(_make_label("No spell scrolls in party inventory", 18, Color(MUTED)))


func _use_scroll(item_id: String) -> void:
	if battle_over or not GameState.Items.SCROLLS.has(item_id) or not _is_standing(selected_hero) or int(hero_state[selected_hero]["ap"]) < 1:
		return
	if not GameState.consume_scroll(item_id):
		return
	hero_state[selected_hero]["ap"] = int(hero_state[selected_hero]["ap"]) - 1
	var item: Dictionary = GameState.Items.item(item_id)
	_add_log("%s consumes %s." % [_name_of(selected_hero), item["name"]])
	var target_index: int = selected_enemy_index
	var phase: int = int(enemies[target_index].get("phase_index", 0))
	var previous_hp: int = int(enemies[target_index]["hp"])
	_deal_enemy_damage(Rules.damage_after_chill(int(item["damage"]), hero_state[selected_hero]["statuses"]), item["effect"] == "pierce")
	if int(enemies[target_index].get("phase_index", 0)) == phase and item_id in ["fire_bolt_scroll", "sunfire_scroll"] and int(enemies[target_index]["hp"]) > 0 and int(enemies[target_index]["hp"]) < previous_hp:
		Rules.apply_status(enemies[target_index]["statuses"], "burn")
		_add_log("%s burns for 2 turns." % enemies[target_index]["name"])
	_check_battle_over()
	_refresh_all()


func _flash(target: Control, tint: Color) -> void:
	if target == null:
		return
	var tween: Tween = create_tween()
	tween.tween_property(target, "modulate", tint, 0.10)
	tween.tween_property(target, "modulate", Color.WHITE, 0.20)


# -------------------- INTERFACE / ART --------------------

func _build_interface() -> void:
	$Background.visible = false
	if GameState.selected_expedition.has("combat_background"):
		$BackgroundArt.texture = load(str(GameState.selected_expedition["combat_background"]))
	round_label = $RoundLabel
	hand_title = $HandTitle
	hand_container = $CardHand/Cards
	log_container = $BattleLog
	end_turn_button = $EndTurnButton
	enemy_label = $Enemy/EnemyInfo
	enemy_intent_label = $Enemy/EnemyIntent
	enemy_art = $Enemy/EnemyArt

	party = GameState.party.duplicate()
	$EncounterHeader/ExpeditionTitle.text = expedition_title.to_upper()
	var enemy_art_node: TextureRect = $Enemy/EnemyArt
	enemy_art_node.texture = _load_texture(enemy_art_path)
	$Enemy/EnemyInfo.add_theme_font_size_override("font_size", 26)
	$Enemy/EnemyInfo.add_theme_color_override("font_color", Color(IVORY))
	$Enemy/EnemyIntent.add_theme_font_size_override("font_size", 22)
	_build_hero_cards()
	enemy_intent_label.add_theme_color_override("font_color", Color(RED))
	end_turn_button.add_theme_font_size_override("font_size", 24)
	round_label.add_theme_color_override("font_color", Color(GOLD))
	hand_title.add_theme_color_override("font_color", Color(GOLD))
	_style_meter($Enemy/HealthBar, Color("#AF343C"))
	var party_frame: Control = $PartyBackdrop
	_style_card_backing(party_frame, Color(0.035, 0.032, 0.04, 0.0), Color(0.56, 0.27, 0.27, 0.0))
	_style_card_backing($EncounterHeader, Color(0.035, 0.032, 0.04, 0.0), Color(0.56, 0.27, 0.27, 0.0))

	gold_label = $GoldLabel
	_layout_combat()


func _place(control: Control, rect: Rect2) -> void:
	control.set_anchors_preset(Control.PRESET_TOP_LEFT)
	control.position = rect.position
	control.size = rect.size


func _layout_combat() -> void:
	$Arena.visible = false
	_place($EncounterHeader, Rect2(660, 24, 600, 86))
	_place(round_label, Rect2(1460, 40, 400, 45))
	_place(gold_label, Rect2(1460, 90, 400, 35))
	_place($Heros, Rect2(580, 650, 790, 340))
	_place($Enemy, Rect2(740, 150, 440, 400))
	($Enemy as Button).flat = false
	_style_card_backing($Enemy, Color("#291C23"), Color(GOLD))
	_place(enemy_art, Rect2(60, 85, 320, 235))
	_place(enemy_label, Rect2(20, 12, 400, 70))
	_place(enemy_intent_label, Rect2(20, 325, 400, 40))
	enemy_intent_label.add_theme_font_size_override("font_size", 19)
	_place($Enemy/HealthBar, Rect2(20, 370, 400, 18))
	_place(hand_title, Rect2(40, 475, 460, 40))
	_place($CardHand, Rect2(40, 530, 470, 540))
	hand_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_place(end_turn_button, Rect2(1470, 950, 400, 80))
	var info_panel := PanelContainer.new()
	info_panel.name = "SelectedHeroInfo"
	_place(info_panel, Rect2(40, 40, 470, 410))
	_style_card_backing(info_panel, Color("#21171D"), Color(GOLD))
	add_child(info_panel)
	var info_contents := Control.new()
	info_panel.add_child(info_contents)
	selected_portrait = TextureRect.new()
	selected_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	selected_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_place(selected_portrait, Rect2(0, 0, 180, 260))
	info_contents.add_child(selected_portrait)
	StatusVisual.new().attach_to(selected_portrait)
	selected_info = _make_label("", 22, Color(IVORY))
	_place(selected_info, Rect2(190, 10, 250, 340))
	selected_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info_contents.add_child(selected_info)
	var hint := _make_label("Select a hero below to inspect their abilities.\nHeroes act in any order during the party turn.", 18, Color(MUTED))
	_place(hint, Rect2(8, 320, 430, 65))
	info_contents.add_child(hint)
	var log_panel := PanelContainer.new()
	_place(log_panel, Rect2(1460, 440, 420, 480))
	_style_card_backing(log_panel, Color("#21171D"), Color(GOLD))
	add_child(log_panel)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	log_panel.add_child(scroll)
	log_container.reparent(scroll)
	log_container.visible = true
	log_container.custom_minimum_size = Vector2(375, 0)
	log_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var caption := _make_label("BATTLE LOG", 24, Color(IVORY))
	_place(caption, Rect2(1460, 390, 400, 40))
	add_child(caption)
	var scroll_title := _make_label("PARTY SPELL SCROLLS", 20, Color(IVORY))
	_place(scroll_title, Rect2(580, 545, 790, 30))
	add_child(scroll_title)
	var scroll_strip := ScrollContainer.new()
	_place(scroll_strip, Rect2(580, 580, 790, 68))
	scroll_strip.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll_strip)
	scroll_container = HBoxContainer.new()
	scroll_strip.add_child(scroll_container)
	scroll_container.add_theme_constant_override("separation", 10)
	_build_enemy_cards()
	if GameState.run_active and GameState.floors[GameState.floor_index][GameState.room_position].get("merchant_orb", false):
		merchant_orb = Button.new()
		merchant_orb.name = "MerchantOrb"
		merchant_orb.icon = load("res://assets/ui/merchant_orb.svg")
		merchant_orb.expand_icon = true
		merchant_orb.add_theme_constant_override("icon_max_width", 48)
		merchant_orb.text = "MERCHANT ORB · SEALED"
		merchant_orb.disabled = true
		merchant_orb.add_theme_font_size_override("font_size", 21)
		_style_card_backing(merchant_orb, Color("#13212B"), Color("#80C9E1"))
		_place(merchant_orb, Rect2(1460, 260, 420, 85))
		merchant_orb.pressed.connect(_enter_merchant_orb)
		add_child(merchant_orb)











func _build_hero_cards() -> void:
	var container: HBoxContainer = $Heros
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	hero_buttons.clear()
	hero_portraits.clear()
	hero_name_labels.clear()
	hero_stat_labels.clear()
	hero_health_bars.clear()
	hero_stress_bars.clear()
	for hero_id in party:
		container.add_child(_make_hero_card(hero_id))


func _make_hero_card(hero_id: String) -> Button:
	var hero: Dictionary = GameState.hero(hero_id)
	var button: Button = $HeroTemplate.duplicate() as Button
	button.custom_minimum_size = Vector2(250.0, 350.0)
	button.size = Vector2(250.0, 350.0)
	button.flat = false
	button.name = "Hero_%s" % hero_id
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(_on_hero_pressed.bind(hero_id))

	button.visible = true
	var portrait: TextureRect = button.get_node("Portrait") as TextureRect
	_place(portrait, Rect2(15, 12, 220, 190))
	portrait.texture = _load_texture(str(hero.get("art", "")))
	hero_portraits[hero_id] = portrait
	StatusVisual.new().attach_to(portrait)
	var name_label: Label = button.get_node("HeroName") as Label
	_place(name_label, Rect2(8, 205, 234, 32))
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	name_label.add_theme_constant_override("shadow_offset_x", 2)
	name_label.add_theme_constant_override("shadow_offset_y", 2)
	hero_name_labels[hero_id] = name_label

	var health: ProgressBar = button.get_node("HealthBar") as ProgressBar
	_place(health, Rect2(18, 245, 214, 16))
	_style_meter(health, Color("#AF343C"))
	hero_health_bars[hero_id] = health
	var stress: ProgressBar = button.get_node("StressBar") as ProgressBar
	_place(stress, Rect2(18, 270, 214, 16))
	_style_meter(stress, Color("#79435C"))
	hero_stress_bars[hero_id] = stress
	var stat_label: Label = button.get_node("Status") as Label
	_place(stat_label, Rect2(8, 295, 234, 28))
	hero_stat_labels[hero_id] = stat_label
	hero_buttons[hero_id] = button
	var effects := _make_label("", 14, Color(RED), true)
	effects.name = "Effects"
	effects.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_place(effects, Rect2(8, 323, 234, 28))
	button.add_child(effects)
	return button


func _create_card_view(card_id: String, card: Dictionary) -> Button:
	var button := Button.new()
	button.name = "Card_%s" % card_id
	button.custom_minimum_size = Vector2(220.0, 170.0)
	_style_card_backing(button, Color("#21171D"), Color(GOLD))
	var contents := Control.new()
	contents.name = "Contents"
	contents.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(contents)
	var header_label := _make_label("", 17, Color(IVORY), true)
	header_label.name = "Header"
	_place(header_label, Rect2(8, 8, 204, 42))
	header_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	contents.add_child(header_label)
	var art_frame := Control.new()
	art_frame.name = "ArtFrame"
	art_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_child(art_frame)
	var picture := TextureRect.new()
	picture.name = "CardArt"
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(picture, Rect2(10, 62, 45, 65))
	art_frame.add_child(picture)
	var effect_label := _make_label("", 14, Color(MUTED), true)
	effect_label.name = "Effect"
	_place(effect_label, Rect2(5, 148, 210, 20))
	contents.add_child(effect_label)
	var description_label := _make_label("", 17, Color(IVORY))
	description_label.name = "Description"
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_place(description_label, Rect2(63, 60, 148, 86))
	contents.add_child(description_label)
	button.visible = true
	button.tooltip_text = GameState.card_description(card) + " Cooldown: %d full party turn(s)." % GameState.ability_cooldown(card_id)
	var level: int = GameState.card_level(card_id)
	var header: String = "%s · %d AP" % [str(card["name"]), int(card["cost"])]
	if level > 0:
		header += " ★%d" % level
	(button.get_node("Contents/Header") as Label).text = header
	var art_path: String = CARD_ART_DIR + card_id + ".png"
	picture.texture = _load_texture(art_path)
	picture.visible = picture.texture != null
	(button.get_node("Contents/Effect") as Label).text = "Cooldown: %d %s" % [GameState.ability_cooldown(card_id), "turn" if GameState.ability_cooldown(card_id) == 1 else "turns"] if GameState.ability_cooldown(card_id) > 0 else "No cooldown"
	(button.get_node("Contents/Description") as Label).text = GameState.card_description(card)
	return button


func _load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return null


# -------------------- STYLE HELPERS --------------------

func _style_card_backing(control: Control, fill: Color, outline: Color) -> void:
	var style_box: StyleBoxFlat = StyleBoxFlat.new()
	style_box.bg_color = fill
	style_box.border_color = outline
	style_box.set_border_width_all(1)
	style_box.set_corner_radius_all(10)
	style_box.set_content_margin_all(12)
	if control is PanelContainer:
		(control as PanelContainer).add_theme_stylebox_override("panel", style_box)
	elif control is Button:
		var button: Button = control as Button
		button.add_theme_stylebox_override("normal", style_box)
		button.add_theme_stylebox_override("hover", style_box)
		button.add_theme_stylebox_override("pressed", style_box)
		var focus_style: StyleBoxFlat = style_box.duplicate() as StyleBoxFlat
		focus_style.bg_color = Color(fill.r, fill.g, fill.b, minf(1.0, fill.a + 0.12))
		button.add_theme_stylebox_override("focus", focus_style)
		var disabled_style: StyleBoxFlat = style_box.duplicate() as StyleBoxFlat
		disabled_style.bg_color = Color(fill.r * 0.65, fill.g * 0.65, fill.b * 0.65, fill.a)
		button.add_theme_stylebox_override("disabled", disabled_style)


func _style_meter(meter: ProgressBar, tint: Color) -> void:
	var background := StyleBoxFlat.new()
	background.bg_color = Color("#100F12")
	background.set_corner_radius_all(3)
	background.border_color = Color(GOLD)
	background.set_border_width_all(1)
	var fill := StyleBoxFlat.new()
	fill.bg_color = tint
	fill.set_corner_radius_all(3)
	meter.add_theme_stylebox_override("background", background)
	meter.add_theme_stylebox_override("fill", fill)


func _make_label(value: String, font_size: int, color: Color, centered: bool = false) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _style(fill: Color, outline: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = outline
	box.set_border_width_all(2)
	box.set_corner_radius_all(8)
	box.set_content_margin_all(14)
	return box


# -------------------- SIGNAL HANDLERS --------------------

func _on_hero_pressed(hero_id: String) -> void:
	_select_hero(hero_id)


func _on_end_turn_button_pressed() -> void:
	if battle_over:
		if GameState.run_active and _living_enemies().is_empty():
			GameState.run_heroes = hero_state.duplicate(true)
			GameState.finish_encounter()
			get_tree().change_scene_to_file("res://scenes/expedition/dungeon.tscn")
		else:
			GameState.end_run()
			get_tree().change_scene_to_file(HUB_SCENE)
	else:
		_end_turn()


func _build_enemy_cards() -> void:
	var template: Button = $Enemy
	for index in range(enemies.size()):
		var view: Button = template if index == 0 else template.duplicate() as Button
		if index > 0:
			view.name = "Enemy_%d" % index
			add_child(view)
		var total_width: float = enemies.size() * 265 - 15
		_place(view, Rect2(975 - total_width * 0.5 + index * 265, 155, 250, 370))
		for child in view.get_children():
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_place(view.get_node("EnemyInfo"), Rect2(10, 10, 230, 65))
		(view.get_node("EnemyInfo") as Label).add_theme_font_size_override("font_size", 18)
		(view.get_node("EnemyInfo") as Label).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_place(view.get_node("EnemyArt"), Rect2(20, 80, 210, 165))
		(view.get_node("EnemyArt") as TextureRect).texture = _load_texture(str(enemies[index]["art"]))
		_place(view.get_node("EnemyIntent"), Rect2(10, 250, 230, 88))
		(view.get_node("EnemyIntent") as Label).add_theme_font_size_override("font_size", 15)
		(view.get_node("EnemyIntent") as Label).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_place(view.get_node("HealthBar"), Rect2(12, 345, 226, 14))
		enemy_views.append(view)
	# Connect after duplication so each button selects only its own target.
	for index in range(enemy_views.size()):
		StatusVisual.new().attach_to(enemy_views[index].get_node("EnemyArt"))
		enemy_views[index].pressed.connect(_select_enemy.bind(index))
	_load_enemy(selected_enemy_index)
	var target_hint := _make_label("Select an enemy to target abilities and scrolls", 18, Color(IVORY), true)
	_place(target_hint, Rect2(580, 115, 790, 30))
	add_child(target_hint)


func _refresh_enemies() -> void:
	_store_enemy()
	var original: int = selected_enemy_index
	for index in range(enemies.size()):
		_load_enemy(index)
		var view: Button = enemy_views[index]
		var entry: Dictionary = enemies[index]
		var label: Label = view.get_node("EnemyInfo")
		label.text = ("▶ " if index == original else "") + "%s\nHP %d / %d · Block %d" % [enemy_name, enemy_hp, enemy_max_hp, enemy_block]
		var intent: Label = view.get_node("EnemyIntent")
		intent.text = ("Stage %d / 3\n" % (int(entry.get("phase_index", 0)) + 1) if entry.has("phase_creatures") else "") + _enemy_intent_text() + "\n" + Rules.status_text(entry["statuses"])
		if enemy_mark_bonus > 0:
			intent.text += " · Mark +%d" % enemy_mark_bonus
		if enemy_weak_rounds > 0:
			intent.text += " · Weak %d" % enemy_weak_rounds
		var meter: ProgressBar = view.get_node("HealthBar")
		meter.max_value = enemy_max_hp
		meter.value = enemy_hp
		_sync_portrait(view.get_node("EnemyArt"), entry)
		view.disabled = battle_over or enemy_hp <= 0
		view.modulate = Color(0.45, 0.45, 0.45) if enemy_hp <= 0 else Color.WHITE
		_style_card_backing(view, Color("#291C23"), Color("#D3AF72") if index == original else Color(GOLD))
	_load_enemy(original)


func _enter_merchant_orb() -> void:
	if not battle_over or not _living_enemies().is_empty() or not GameState.run_active:
		return
	GameState.run_heroes = hero_state.duplicate(true)
	GameState.finish_encounter()
	if not GameState.merchant_orb_available():
		return
	GameState.shop_return_scene = "res://scenes/expedition/dungeon.tscn"
	get_tree().change_scene_to_file("res://scenes/hub/item_shop.tscn")


func _sync_portrait(portrait: TextureRect, state: Dictionary) -> void:
	var visual = portrait.get_node("StatusVisual")
	visual.sync(state.get("statuses", {}), int(state["hp"]), int(state["max_hp"]), bool(state.get("dead", int(state["hp"]) <= 0)), int(state.get("weak", 0)), state.get("resolve_type", "") == "affliction")

func _hurt_portrait(portrait: TextureRect) -> void:
	if is_instance_valid(portrait) and portrait.has_node("StatusVisual"):
		portrait.get_node("StatusVisual").hurt()
