extends Node2D

var _main_scene: Node2D
var _game_space: Node2D
var _center: Node2D
var _enemy: Node2D
var _enemy_ship_parts: Node2D
var _player: Node2D
var _player_ship_parts: Node2D
var _continue_button: Node2D
var _sprite_fadeaway: Node2D
var _enemy_health_bar: Node2D
var _colorize_screen: Node2D

var _seperate_ship_parts_callback = []
var _make_upgrades_clickable_callback = []
var _start_warp_callback = []
var _warp_callback = []

var target_upgrade_option: Node2D
var possible_replaceable_parts: int

@export var animation_len_secs: float = 1.0;
@export var upgrade_prefab_path: String
@export var player_part_prefab_path: String


func _ready():
	_main_scene = get_node('/root/main_scene');
	_sprite_fadeaway = get_node('/root/main_scene/sprite_fadeaway');
	_center = get_node('/root/main_scene/center');
	_game_space = get_node('/root/main_scene/game_space');
	_enemy = get_node('/root/main_scene/game_space/enemy');
	_enemy_ship_parts = get_node('./enemy_ship_parts')
	_player = get_node('/root/main_scene/game_space/player');
	_player_ship_parts = get_node('./player_ship_parts')
	_continue_button = get_node('/root/main_scene/ui/continue_button')
	_enemy_health_bar = get_node('/root/main_scene/ui/enemy_health_bar')
	_colorize_screen = get_node('/root/main_scene/colorize_screen')

func activate_upgrade_phase():
	var enemy_ship_parts = []
	var player_ship_parts = []
	_player_ship_parts.modulate = Color.WHITE;

	for child in _main_scene.get_children_in_groups(_game_space, ['enemy_ship_part'], true):
		enemy_ship_parts.append([child.global_position.x, child])
	for child in _main_scene.get_children_in_groups(_game_space, ['player_ship_part'], true):
		player_ship_parts.append([child.global_position.x, child])

	enemy_ship_parts.sort()
	var ordered_enemy_ship_parts = []
	player_ship_parts.sort()
	var ordered_player_ship_parts = []

	for part in enemy_ship_parts:
		ordered_enemy_ship_parts.append(part[1]);
	for part in player_ship_parts:
		ordered_player_ship_parts.append(part[1]);

	_enemy_ship_parts.global_position = _enemy.global_position
	var avg_enemy_local_pos = Vector2.ZERO;
	var upgrade_options = []
	_player_ship_parts.global_position = _player.global_position
	var avg_player_local_pos = Vector2.ZERO;
	var player_ship_parts_upgradeables = []

	for part in ordered_enemy_ship_parts:
		var upgrade_option = _main_scene.create_node(upgrade_prefab_path, _enemy_ship_parts);
		upgrade_option.global_position = part.global_position;
		upgrade_option.initialize_from_part(part);

		avg_enemy_local_pos += upgrade_option.global_position - _enemy.global_position;
		upgrade_options.append(upgrade_option);
	
	for part in ordered_player_ship_parts:
		var player_ship_parts_upgradeable = _main_scene.create_node(player_part_prefab_path, _player_ship_parts);
		player_ship_parts_upgradeable.global_position = part.global_position;
		player_ship_parts_upgradeable.initialize_from_part(part);

		avg_player_local_pos += player_ship_parts_upgradeable.global_position - _player.global_position;
		player_ship_parts_upgradeables.append(player_ship_parts_upgradeable);
	
	avg_enemy_local_pos = avg_enemy_local_pos / len(ordered_enemy_ship_parts)
	avg_player_local_pos = avg_player_local_pos / len(ordered_player_ship_parts)

	for option in upgrade_options:
		option.position = option.position - avg_enemy_local_pos;
	_enemy_ship_parts.global_position = _enemy_ship_parts.global_position + avg_enemy_local_pos;
	for player_ship_parts_upgradeable in player_ship_parts_upgradeables:
		player_ship_parts_upgradeable.position = player_ship_parts_upgradeable.position - avg_player_local_pos;
	_player_ship_parts.global_position = _player_ship_parts.global_position + avg_player_local_pos;

	_seperate_ship_parts_callback = []

	_enemy_ship_parts.animation_len_secs = animation_len_secs;
	_seperate_ship_parts_callback.append(_enemy_ship_parts.get_path());
	_enemy_ship_parts.set_lerp_to_pos(Vector2(_center.global_position.x, _enemy_ship_parts.global_position.y), _main_scene.soft_curve, self);

	_player_ship_parts.animation_len_secs = animation_len_secs;
	_seperate_ship_parts_callback.append(_player_ship_parts.get_path());
	_player_ship_parts.set_lerp_to_pos(Vector2(_center.global_position.x, _player_ship_parts.global_position.y - 40), _main_scene.soft_curve, self);
	
	for child in _main_scene.get_children_in_groups(_game_space, ['enemy_ship_part'], true):
		child.queue_free()
	for child in _main_scene.get_children_in_groups(_game_space, ['player_ship_part'], true):
		child.queue_free()

func finish_lerp_to_pos(node):
	var _potential_seperate_ship_parts = false;
	var _potential_make_upgrades_clickable = false;
	var _potential_start_warp = false
	var _potential_warp = false

	if len(_seperate_ship_parts_callback) > 0:
		_potential_seperate_ship_parts = true;
	if len(_make_upgrades_clickable_callback) > 0:
		_potential_make_upgrades_clickable = true;
	if len(_start_warp_callback) > 0:
		_potential_start_warp = true;
	if len(_warp_callback) > 0:
		_potential_warp = true;

	_seperate_ship_parts_callback.erase(node.get_path());
	_make_upgrades_clickable_callback.erase(node.get_path());
	_start_warp_callback.erase(node.get_path());
	_warp_callback.erase(node.get_path());

	if _potential_seperate_ship_parts and (len(_seperate_ship_parts_callback) == 0):
		_seperate_ship_parts()
	if _potential_make_upgrades_clickable and (len(_make_upgrades_clickable_callback) == 0):
		_make_upgrades_clickable()
	if _potential_start_warp and (len(_start_warp_callback) == 0):
		_start_warp()
	if _potential_warp and (len(_warp_callback) == 0):
		_finish_warp()

func _seperate_ship_parts():
	_make_upgrades_clickable_callback = [];

	for child in _enemy_ship_parts.get_children():
		child.animation_len_secs = animation_len_secs;
		_make_upgrades_clickable_callback.append(child.get_path());
		var pos = _enemy_ship_parts.global_position + child.position * 1.2
		child.set_lerp_to_pos(pos, _main_scene.soft_curve, self, child)

	for child in _player_ship_parts.get_children():
		child.animation_len_secs = animation_len_secs;
		_make_upgrades_clickable_callback.append(child.get_path());
		var pos = _player_ship_parts.global_position + child.position * 1.2
		child.set_lerp_to_pos(pos, _main_scene.soft_curve, self, child)

func _make_upgrades_clickable():
	possible_replaceable_parts = 1
	_update_upgrades_clickable()

func _update_upgrades_clickable():
	for child in _enemy_ship_parts.get_children():
		child.update_clickable_state()

	for child in _player_ship_parts.get_children():
		child.update_clickable_state()
	
	_continue_button.enable()

func set_target_upgrade_option(new_target_upgrade_option):
	target_upgrade_option = new_target_upgrade_option;
	_update_upgrades_clickable()

func continue_button_pressed():
	_continue_button.disable()

	for child in _enemy_ship_parts.get_children():
		_sprite_fadeaway.destroy(child)

	for child in _player_ship_parts.get_children():
		child.make_unclickable()
		child.animation_len_secs = animation_len_secs;
		_start_warp_callback.append(child.get_path());
		var pos = round(_player_ship_parts.global_position + child.position * (1/1.2))
		child.set_lerp_to_pos(pos, _main_scene.soft_curve, self, child)

func _start_warp():
	_enemy_health_bar.hide_health_bar();
	_player_ship_parts.animation_len_secs = animation_len_secs;
	_warp_callback.append(_player_ship_parts.get_path());
	var pos = _player_ship_parts.global_position + (Vector2.UP * 100.0)
	_player_ship_parts.set_lerp_to_pos(pos, _main_scene.rising_curve, self, _player_ship_parts, 'fade_out')

	_colorize_screen.animation_len_secs = animation_len_secs;
	_warp_callback.append(_colorize_screen.get_path());
	_colorize_screen.set_lerp_to_pos(_colorize_screen.global_position, _main_scene.rising_curve, self, _colorize_screen, 'fade_in')

func _finish_warp():
	for child in _player_ship_parts.get_children():
		var part = child.create_part()
		part.reparent(_player);
		part.global_position.y = _player.global_position.y;
		child.queue_free();
	
	_game_space.go_to_next_battle()

