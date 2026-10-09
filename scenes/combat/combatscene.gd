extends Control
## Ashen Expedition — a Slay-the-Spire-style deckbuilder with Darkest Dungeon
## flavour. The party, heroes, decks and enemy are read from GameState, so the
## roster can change in the Barracks. Includes Death's Door, the Stress resolve
## test, and the Healer's self/team healing and bonus damage against Undead.

# Shared game data/state, preloaded by path (no global class registry needed).
const GameState := preload("res://scripts/game_data.gd")

const PANEL = "#211519"
const GOLD = "#8F4546"
const IVORY = "#EADDD0"
const MUTED = "#B5A2A3"
const RED = "#DF7870"
const VIRTUE_COLOR = "#8FB07A"
const AFFLICTION_COLOR = "#C25A55"

const ART_BACKGROUND = "res://assets/generated/bg_crypt.png"
const CARD_ART_DIR = "res://assets/generated/"
const DEFAULT_ENEMY_NAME = "Hollow Villager"
const DEFAULT_ENEMY_MAX_HP = 68
const DEFAULT_ENEMY_ATTACK = 7
const DEFAULT_ENEMY_ART = "res://assets/generated/enemy_hollow_villager.png"
const HUB_SCENE = "res://scenes/hub/settlement.tscn"
## When opened directly (F6) with no expedition chosen, return to the Hamlet
## instead of starting a default battle. Set false to test a battle in isolation.
const REQUIRE_EXPEDITION := true

const AFFLICTIONS: Array[String] = ["Paranoid", "Masochistic", "Abusive", "Irrational", "Hopeless", "Fearful"]
const VIRTUES: Array[String] = ["Stalwart", "Courageous", "Focused", "Powerful", "Vigorous", "Vigilant"]
const VIRTUE_CHANCE = 0.25

var party: Array = []
var hero_state: Dictionary = {}
var hero_buttons: Dictionary = {}
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
var hand_container: HBoxContainer
var log_container: VBoxContainer
var end_turn_button: Button
var enemy_label: Label
var enemy_intent_label: Label
var enemy_art: Control
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
	if hand.is_empty():
		hand_container.add_child(_make_label("No cards in hand. End the party turn to draw again.", 23, Color(MUTED)))


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
	round_label = $RoundLabel
	hand_title = $HandTitle
	hand_container = $CardHand/Cards
	log_container = $BattleLog
	end_turn_button = $EndTurnButton
	enemy_label = $Enemy/EnemyInfo
	enemy_intent_label = $Enemy/EnemyIntent
	enemy_art = $Enemy

	party = GameState.party.duplicate()
	_add_title()
	_build_background()
	_layout_regions()
	_build_enemy()
	_build_hero_cards()

	enemy_intent_label.add_theme_color_override("font_color", Color(RED))
	end_turn_button.add_theme_font_size_override("font_size", 24)
	round_label.add_theme_color_override("font_color", Color(GOLD))
	hand_title.add_theme_color_override("font_color", Color(GOLD))
	_style_meter($Enemy/HealthBar, Color("#AF343C"))

	embers_label = _make_label("", 20, Color(GOLD))
	embers_label.position = Vector2(7.0, 72.0)
	embers_label.size = Vector2(340.0, 30.0)
	add_child(embers_label)


func _add_title() -> void:
	var title: Label = _make_label("ASHEN  EXPEDITION", 34, Color(IVORY), true)
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	title.add_theme_constant_override("shadow_offset_x", 2)
	title.add_theme_constant_override("shadow_offset_y", 2)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(title)
	title.position = Vector2(size.x * 0.5 - 260.0, 10.0)
	title.size = Vector2(520.0, 44.0)
	var subtitle: Label = _make_label(expedition_title.to_upper(), 20, Color(GOLD), true)
	subtitle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(subtitle)
	subtitle.position = Vector2(size.x * 0.5 - 260.0, 50.0)
	subtitle.size = Vector2(520.0, 30.0)


func _build_background() -> void:
	var overlay: ColorRect = $Background
	overlay.color = Color(0.04, 0.03, 0.038, 0.62)
	var art := TextureRect.new()
	art.name = "BackgroundArt"
	art.texture = _load_texture(ART_BACKGROUND)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.z_index = -2
	add_child(art)
	art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _layout_regions() -> void:
	var heroes: HBoxContainer = $Heros
	heroes.anchor_left = 0.0
	heroes.anchor_top = 0.0
	heroes.anchor_right = 0.0
	heroes.anchor_bottom = 0.0
	heroes.offset_left = 452.0
	heroes.offset_top = 742.0
	heroes.offset_right = 1300.0
	heroes.offset_bottom = 1050.0

	var hand: ScrollContainer = $CardHand
	hand.anchor_left = 0.0
	hand.anchor_top = 0.0
	hand.anchor_right = 0.0
	hand.anchor_bottom = 0.0
	hand.offset_left = 16.0
	hand.offset_top = 330.0
	hand.offset_right = 770.0
	hand.offset_bottom = 700.0

	hand_title.position = Vector2(18.0, 292.0)
	hand_title.size = Vector2(320.0, 34.0)

	var log_box: VBoxContainer = $BattleLog
	log_box.offset_left = 1380.0
	log_box.offset_right = 1904.0

	end_turn_button.position = Vector2(1596.0, 968.0)
	end_turn_button.size = Vector2(300.0, 72.0)


func _build_enemy() -> void:
	var enemy: Button = $Enemy
	enemy.anchor_left = 0.0
	enemy.anchor_top = 0.0
	enemy.anchor_right = 0.0
	enemy.anchor_bottom = 0.0
	enemy.offset_left = 730.0
	enemy.offset_top = 96.0
	enemy.offset_right = 1190.0
	enemy.offset_bottom = 470.0

	var art := TextureRect.new()
	art.texture = _load_texture(enemy_art_path)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	enemy.add_child(art)
	enemy.move_child(art, 0)
	art.position = Vector2(120.0, 84.0)
	art.size = Vector2(220.0, 210.0)

	enemy_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	enemy_label.position = Vector2(8.0, 2.0)
	enemy_label.size = Vector2(444.0, 78.0)
	enemy_label.add_theme_font_size_override("font_size", 26)
	enemy_label.add_theme_color_override("font_color", Color(IVORY))
	enemy_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	enemy_label.add_theme_constant_override("shadow_offset_x", 2)
	enemy_label.add_theme_constant_override("shadow_offset_y", 2)

	enemy_intent_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	enemy_intent_label.position = Vector2(8.0, 302.0)
	enemy_intent_label.size = Vector2(444.0, 40.0)
	enemy_intent_label.add_theme_font_size_override("font_size", 22)
	enemy_intent_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	enemy_intent_label.add_theme_constant_override("shadow_offset_x", 2)
	enemy_intent_label.add_theme_constant_override("shadow_offset_y", 2)

	var health: ProgressBar = enemy.get_node("HealthBar")
	health.anchor_top = 0.0
	health.anchor_bottom = 0.0
	health.anchor_right = 0.0
	health.position = Vector2(20.0, 348.0)
	health.size = Vector2(420.0, 20.0)


func _build_hero_cards() -> void:
	var container: HBoxContainer = $Heros
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	hero_buttons.clear()
	hero_name_labels.clear()
	hero_stat_labels.clear()
	hero_health_bars.clear()
	hero_stress_bars.clear()
	for hero_id in party:
		container.add_child(_make_hero_card(hero_id))


func _make_hero_card(hero_id: String) -> Button:
	var hero: Dictionary = GameState.hero(hero_id)
	var button := _make_button("", Vector2(280.0, 300.0))
	button.clip_text = false
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(_on_hero_pressed.bind(hero_id))

	var portrait := TextureRect.new()
	portrait.texture = _load_texture(str(hero.get("art", "")))
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(portrait)
	portrait.position = Vector2(18.0, 10.0)
	portrait.size = Vector2(244.0, 176.0)

	var name_label: Label = _make_label("", 22, Color(IVORY), true)
	name_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	name_label.add_theme_constant_override("shadow_offset_x", 2)
	name_label.add_theme_constant_override("shadow_offset_y", 2)
	button.add_child(name_label)
	name_label.position = Vector2(8.0, 188.0)
	name_label.size = Vector2(264.0, 30.0)
	hero_name_labels[hero_id] = name_label

	var health := ProgressBar.new()
	health.max_value = 100
	health.value = 100
	health.show_percentage = false
	health.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(health)
	health.position = Vector2(20.0, 224.0)
	health.size = Vector2(240.0, 16.0)
	_style_meter(health, Color("#AF343C"))
	hero_health_bars[hero_id] = health

	var stress := ProgressBar.new()
	stress.max_value = 100
	stress.value = 0
	stress.show_percentage = false
	stress.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(stress)
	stress.position = Vector2(20.0, 246.0)
	stress.size = Vector2(240.0, 16.0)
	_style_meter(stress, Color("#79435C"))
	hero_stress_bars[hero_id] = stress

	var stat_label: Label = _make_label("", 15, Color(MUTED), true)
	button.add_child(stat_label)
	stat_label.position = Vector2(6.0, 268.0)
	stat_label.size = Vector2(268.0, 28.0)
	hero_stat_labels[hero_id] = stat_label

	hero_buttons[hero_id] = button
	return button


func _create_card_view(card_id: String, card: Dictionary) -> Button:
	var button := _make_button("", Vector2(220.0, 296.0))
	button.tooltip_text = str(card["description"])
	var contents := VBoxContainer.new()
	contents.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_theme_constant_override("separation", 6)
	button.add_child(contents)
	contents.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	contents.offset_left = 12
	contents.offset_top = 10
	contents.offset_right = -12
	contents.offset_bottom = -10
	var level: int = GameState.card_level(card_id)
	var header: String = "%s    ·    %d AP" % [str(card["name"]), int(card["cost"])]
	if level > 0:
		header += "    ★%d" % level
	contents.add_child(_make_label(header, 18, Color(IVORY), true))
	var picture := _art_slot(contents, CARD_ART_DIR + card_id + ".png", str(card["effect"]).to_upper(), Vector2(188.0, 150.0))
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_child(_make_label(str(card["effect"]).to_upper(), 15, Color(GOLD), true))
	var description: Label = _make_label(GameState.card_description(card), 16, Color(IVORY), true)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	contents.add_child(description)
	return button


func _art_slot(parent: Control, texture_path: String, fallback: String, min_size: Vector2) -> Control:
	var frame := _make_panel(Color("#25171D"))
	frame.custom_minimum_size = min_size
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(frame)
	var texture: Texture2D = _load_texture(texture_path)
	if texture != null:
		var picture := TextureRect.new()
		picture.texture = texture
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		frame.add_child(picture)
		picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	else:
		var placeholder := _make_label(fallback, 31, Color(GOLD), true)
		placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		frame.add_child(placeholder)
		placeholder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return frame


func _load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return null


# -------------------- STYLE HELPERS --------------------

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


func _make_panel(bg_color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(bg_color, Color(GOLD)))
	return panel


func _make_label(value: String, font_size: int, color: Color, centered: bool = false) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _make_button(value: String, min_size: Vector2) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = min_size
	button.add_theme_font_size_override("font_size", 23)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color", "font_focus_color"]:
		button.add_theme_color_override(state, Color(IVORY))
	var normal := _style(Color(PANEL), Color(GOLD))
	var hover := _style(Color("#452029"), Color("#D68177"))
	var pressed := _style(Color("#5D202D"), Color("#D68177"))
	var disabled := _style(Color("#171216"), Color("#4B343D"))
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("disabled", disabled)
	button.add_theme_stylebox_override("focus", _style(Color.TRANSPARENT, Color("#E6A095")))
	return button


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
