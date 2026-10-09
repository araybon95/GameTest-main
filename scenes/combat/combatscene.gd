extends Control
## Ashen Expedition — a Slay-the-Spire-style deckbuilder with Darkest Dungeon
## flavour. The party, heroes, decks and enemy are read from GameState, so the
## roster can change in the Barracks. Includes Death's Door, the Stress resolve
## test, and the Healer's self/team healing and bonus damage against Undead.

# Shared game data/state, preloaded by path (no global class registry needed).
const GameState := preload("res://scripts/game_data.gd")

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
var embers_label: Label


func _ready() -> void:
	if REQUIRE_EXPEDITION and GameState.selected_expedition.is_empty():
		get_tree().call_deferred("change_scene_to_file", HUB_SCENE)
		return
	_apply_expedition()
	_build_interface()
	_start_battle()


func _apply_expedition() -> void:
	var expedition: Dictionary = GameState.selected_expedition
	if expedition.is_empty():
		expedition_title = "The Old Road"
		_use_creature("hollow_villager")
		return
	expedition_title = str(expedition.get("name", "The Old Road"))
	_use_creature(str(expedition.get("creature", "hollow_villager")))


func _use_creature(creature_id: String) -> void:
	var creature: Dictionary = GameState.creature(creature_id)
	if creature.is_empty():
		enemy_name = DEFAULT_ENEMY_NAME
		enemy_max_hp = DEFAULT_ENEMY_MAX_HP
		enemy_attack_base = DEFAULT_ENEMY_ATTACK
		enemy_art_path = DEFAULT_ENEMY_ART
		enemy_undead = false
		return
	enemy_name = str(creature.get("name", DEFAULT_ENEMY_NAME))
	enemy_max_hp = maxi(1, int(creature.get("hp", DEFAULT_ENEMY_MAX_HP)))
	enemy_attack_base = int(creature.get("attack", DEFAULT_ENEMY_ATTACK))
	enemy_art_path = str(creature.get("art", DEFAULT_ENEMY_ART))
	enemy_undead = bool(creature.get("undead", false))
	GameState.discover_creature(creature_id)


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
		var deck: Array = (hero.get("deck", []) as Array).duplicate()
		deck.shuffle()
		var max_hp: int = int(hero.get("max_hp", 40))
		hero_state[hero_id] = {
			"name": str(hero.get("name", hero_id)),
			"hp": max_hp,
			"max_hp": max_hp,
			"block": 0,
			"ap": 2,
			"stress": 0,
			"draw": deck,
			"hand": [],
			"discard": [],
			"dead": false,
			"deaths_door": false,
			"damage_mod": 0,
			"stress_per_turn": 0,
			"resolved": false,
			"resolve_tag": "",
			"resolve_type": ""
		}
		_draw_cards(hero_id, 3)

	selected_hero = str(party[0]) if not party.is_empty() else ""
	_add_log("%s — a %s blocks the path." % [expedition_title, enemy_name])
	_add_log("%d heroes. %d decks. One party turn." % [party.size(), party.size()])
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


func _draw_cards(hero_id: String, amount: int) -> void:
	var state: Dictionary = hero_state[hero_id]
	for i in range(amount):
		if state["draw"].is_empty():
			if state["discard"].is_empty():
				break
			state["draw"] = state["discard"].duplicate()
			state["discard"].clear()
			state["draw"].shuffle()
			_add_log(_name_of(hero_id) + " reshuffles their discard pile.")
		state["hand"].append(state["draw"].pop_back())


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
	if card_index < 0 or card_index >= state["hand"].size():
		return
	var card_id: String = str(state["hand"][card_index])
	var card: Dictionary = GameState.card_stats(card_id)
	if int(state["ap"]) < int(card["cost"]):
		return

	state["ap"] = int(state["ap"]) - int(card["cost"])
	state["discard"].append(state["hand"].pop_at(card_index))
	_add_log("%s plays %s." % [_name_of(hero_id), card["name"]])
	_resolve_card(hero_id, card)

	if enemy_hp <= 0:
		battle_over = true
		_add_log("VICTORY — the %s falls." % enemy_name)
		_award_reward()
	_refresh_all()


func _attack_damage(hero_id: String, card: Dictionary) -> int:
	var dmg: int = int(card.get("damage", 0)) + int(hero_state[hero_id]["damage_mod"])
	if enemy_undead and card.has("undead_bonus"):
		dmg += int(card["undead_bonus"])
	return dmg


func _resolve_card(hero_id: String, card: Dictionary) -> void:
	match str(card["effect"]):
		"attack":
			_deal_enemy_damage(_attack_damage(hero_id, card))
		"pierce":
			_deal_enemy_damage(_attack_damage(hero_id, card), true)
		"block":
			_gain_block(hero_id, int(card["block"]))
		"attack_block":
			_deal_enemy_damage(_attack_damage(hero_id, card))
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
			_deal_enemy_damage(_attack_damage(hero_id, card))
			_heal_hero(hero_id, int(card["heal"]))
		"stress_attack":
			_deal_enemy_damage(_attack_damage(hero_id, card))
			_gain_stress(hero_id, int(card["stress"]))


# -------------------- ENEMY --------------------

func _enemy_attack_power() -> int:
	var base: int = enemy_attack_base + ((round_number - 1) % 3) * 2
	if enemy_weak_rounds > 0:
		base = maxi(0, base - 3)
	return base


func _enemy_target() -> String:
	var standing: Array = _standing_heroes()
	if standing.is_empty():
		return ""
	return str(standing[(round_number - 1) % standing.size()])


func _enemy_action() -> void:
	# Every fourth turn the enemy braces instead of striking.
	if (round_number - 1) % 4 == 3:
		enemy_block += 8
		_add_log("%s braces: gains 8 Block." % enemy_name)
		return

	var target: String = _enemy_target()
	if target == "":
		return
	var attack: int = _enemy_attack_power()
	if enemy_weak_rounds > 0:
		enemy_weak_rounds -= 1
	_apply_damage(target, attack)
	_add_log("%s attacks %s for %d." % [enemy_name, _name_of(target), attack])
	_gain_stress(target, 2)


func _enemy_intent_text() -> String:
	if battle_over:
		return "Encounter finished"
	if (round_number - 1) % 4 == 3:
		return "INTENT: Brace · Gain 8 Block"
	var target: String = _enemy_target()
	if target == "":
		return "INTENT: —"
	return "INTENT: Strike %s for %d" % [_name_of(target), _enemy_attack_power()]


# -------------------- DAMAGE / HEAL / STRESS --------------------

func _deal_enemy_damage(amount: int, ignore_block: bool = false) -> void:
	var total: int = amount + enemy_mark_bonus
	enemy_mark_bonus = 0
	var absorbed: int = 0
	if not ignore_block:
		absorbed = mini(total, enemy_block)
		enemy_block -= absorbed
	var damage: int = total - absorbed
	enemy_hp = maxi(0, enemy_hp - damage)
	_add_log("%s takes %d damage%s." % [enemy_name, damage, " (%d blocked)" % absorbed if absorbed > 0 else ""])
	_flash(enemy_art, Color("#E78A84"))


func _apply_damage(hero_id: String, amount: int) -> void:
	var state: Dictionary = hero_state[hero_id]
	if bool(state["dead"]):
		return
	var absorbed: int = mini(amount, int(state["block"]))
	state["block"] = int(state["block"]) - absorbed
	var damage: int = amount - absorbed
	if damage <= 0:
		_add_log("%s blocks the blow." % _name_of(hero_id))
		_flash(hero_buttons[hero_id], Color("#C9C4B0"))
		return
	_flash(hero_buttons[hero_id], Color("#E78A84"))
	if bool(state["deaths_door"]) or int(state["hp"]) <= 0:
		state["dead"] = true
		state["deaths_door"] = false
		_add_log("%s is slain at Death's Door!" % _name_of(hero_id))
		return
	var remaining: int = int(state["hp"]) - damage
	if remaining <= 0:
		state["hp"] = 0
		state["deaths_door"] = true
		_add_log("%s takes %d damage and stands at DEATH'S DOOR!" % [_name_of(hero_id), damage])
	else:
		state["hp"] = remaining
		_add_log("%s takes %d damage%s." % [_name_of(hero_id), damage, " (%d blocked)" % absorbed if absorbed > 0 else ""])


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

	_enemy_action()
	if enemy_hp <= 0:
		battle_over = true
		_add_log("VICTORY — the %s falls." % enemy_name)
		_award_reward()

	if not battle_over and _standing_heroes().is_empty():
		battle_over = true
		_add_log("DEFEAT — the party has fallen.")

	if battle_over:
		_refresh_all()
		return

	# Block wears off; standing heroes refill AP, gain on-going stress and draw.
	for hero_id in party:
		var state: Dictionary = hero_state[hero_id]
		state["block"] = 0
		if _is_standing(hero_id):
			state["ap"] = 2
			_gain_stress(hero_id, int(state["stress_per_turn"]))
			_draw_cards(hero_id, 1)
		else:
			state["ap"] = 0

	round_number += 1
	if not _is_standing(selected_hero):
		var survivors: Array = _standing_heroes()
		if not survivors.is_empty():
			selected_hero = str(survivors[0])
	_add_log("Round %d begins." % round_number)
	_refresh_all()


# -------------------- VIEW REFRESH --------------------

func _refresh_all() -> void:
	round_label.text = "ROUND %d" % round_number
	embers_label.text = "EMBERS  %d" % GameState.embers
	if not hero_state.has(selected_hero):
		return
	var hero: Dictionary = hero_state[selected_hero]
	hand_title.text = "%s  ·  %d/2 AP  ·  Draw %d  ·  Hand %d  ·  Discard %d" % [
		str(hero["name"]), int(hero["ap"]), hero["draw"].size(), hero["hand"].size(), hero["discard"].size()
	]
	for hero_id in party:
		var state: Dictionary = hero_state[hero_id]
		var tag: String = ""
		if str(state["resolve_tag"]) != "":
			tag = "  [" + str(state["resolve_tag"]).to_upper() + "]"
		var name_label: Label = hero_name_labels[hero_id]
		name_label.text = ("▶ " if hero_id == selected_hero else "") + str(state["name"]).to_upper() + tag
		var portrait: TextureRect = hero_portraits[hero_id]
		portrait.modulate = Color(0.5, 0.5, 0.54, 0.8) if bool(state["dead"]) else Color.WHITE
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

		var button: Button = hero_buttons[hero_id]
		var health: ProgressBar = hero_health_bars[hero_id]
		health.max_value = int(state["max_hp"])
		health.value = int(state["hp"])
		hero_stress_bars[hero_id].value = int(state["stress"])
		button.disabled = battle_over or not _is_standing(hero_id)
		button.modulate = Color(0.55, 0.55, 0.6) if bool(state["dead"]) else Color.WHITE

	enemy_label.text = "%s\nHP %d / %d     Block %d%s" % [
		enemy_name.to_upper(), enemy_hp, enemy_max_hp, enemy_block,
		"     Mark +%d" % enemy_mark_bonus if enemy_mark_bonus > 0 else ""
	]
	$Enemy/HealthBar.max_value = enemy_max_hp
	$Enemy/HealthBar.value = enemy_hp
	enemy_intent_label.text = _enemy_intent_text()
	end_turn_button.disabled = battle_over
	end_turn_button.text = "END PARTY TURN" if not battle_over else "RETURN TO THE HAMLET"
	_refresh_hand()
	_refresh_log()


func _refresh_hand() -> void:
	for child in hand_container.get_children():
		hand_container.remove_child(child)
		child.queue_free()
	if not hero_state.has(selected_hero):
		return
	var hand: Array = hero_state[selected_hero]["hand"]
	for index in range(hand.size()):
		var card_id: String = str(hand[index])
		var card: Dictionary = GameState.card_stats(card_id)
		var view: Button = _create_card_view(card_id, card)
		view.disabled = battle_over or int(hero_state[selected_hero]["ap"]) < int(card["cost"])
		view.pressed.connect(_play_card.bind(selected_hero, index))
		hand_container.add_child(view)
		var card_width: float = 190.0
		var card_step: float = 165.0
		var card_total_width: float = card_width + float(maxi(0, hand.size() - 1)) * card_step
		var centered_start: float = (hand_container.size.x - card_total_width) * 0.5
		var fan_ratio: float = float(index) - float(hand.size() - 1) * 0.5
		var card_position: Vector2 = Vector2(centered_start + index * card_step, 25.0 + absf(fan_ratio) * 13.0)
		view.position = card_position
		view.size = Vector2(card_width, 270.0)
		view.z_index = index
	if hand.is_empty():
		var empty_label: Label = _make_label("No cards in hand. End the party turn to draw again.", 23, Color(MUTED))
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
	var reward := 5
	if not GameState.selected_expedition.is_empty():
		reward = int(GameState.selected_expedition.get("reward", 5))
	GameState.embers += reward
	_add_log("Spoils: +%d Embers (total %d)." % [reward, GameState.embers])


func _flash(target: Control, tint: Color) -> void:
	if target == null:
		return
	var tween: Tween = create_tween()
	tween.tween_property(target, "modulate", tint, 0.10)
	tween.tween_property(target, "modulate", Color.WHITE, 0.20)


# -------------------- INTERFACE / ART --------------------

func _build_interface() -> void:
	$Background.visible = false
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

	embers_label = $EmbersLabel











func _build_hero_cards() -> void:
	var container: VBoxContainer = $Heros
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
	button.custom_minimum_size = Vector2(380.0, 170.0)
	button.size = Vector2(380.0, 170.0)
	button.name = "Hero_%s" % hero_id
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(_on_hero_pressed.bind(hero_id))

	button.visible = true
	var portrait: TextureRect = button.get_node("Portrait") as TextureRect
	portrait.texture = _load_texture(str(hero.get("art", "")))
	hero_portraits[hero_id] = portrait
	var name_label: Label = button.get_node("HeroName") as Label
	name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	name_label.add_theme_constant_override("shadow_offset_x", 2)
	name_label.add_theme_constant_override("shadow_offset_y", 2)
	hero_name_labels[hero_id] = name_label

	var health: ProgressBar = button.get_node("HealthBar") as ProgressBar
	_style_meter(health, Color("#AF343C"))
	hero_health_bars[hero_id] = health
	var stress: ProgressBar = button.get_node("StressBar") as ProgressBar
	_style_meter(stress, Color("#79435C"))
	hero_stress_bars[hero_id] = stress
	var stat_label: Label = button.get_node("Status") as Label
	hero_stat_labels[hero_id] = stat_label
	hero_buttons[hero_id] = button
	return button


func _create_card_view(card_id: String, card: Dictionary) -> Button:
	var button: Button = $CardTemplate.duplicate() as Button
	button.name = "Card_%s" % card_id
	button.custom_minimum_size = Vector2(190.0, 270.0)
	button.visible = true
	button.tooltip_text = GameState.card_description(card)
	var level: int = GameState.card_level(card_id)
	var header: String = "%s    ·    %d AP" % [str(card["name"]), int(card["cost"])]
	if level > 0:
		header += "    ★%d" % level
	(button.get_node("Contents/Header") as Label).text = header
	var picture: TextureRect = button.get_node("Contents/ArtFrame/CardArt") as TextureRect
	var art_path: String = CARD_ART_DIR + card_id + ".png"
	picture.texture = _load_texture(art_path)
	picture.visible = picture.texture != null
	(button.get_node("Contents/Effect") as Label).text = str(card["effect"]).to_upper()
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
		get_tree().change_scene_to_file(HUB_SCENE)
	else:
		_end_turn()
