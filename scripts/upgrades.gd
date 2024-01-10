extends Node2D

var _main_scene: Node2D
var _game_space: Node2D
var _center: Node2D
var _enemy: Node2D
var _enemy_ship_parts: Node2D

var _enemy_ship_parts_callback = []
var _parts_callback = []

@export var animation_len_secs: float = 1.0;
@export var upgrade_prefab_path: String


func _ready():
	_main_scene = get_node('/root/main_scene');
	_center = get_node('/root/main_scene/center');
	_game_space = get_node('/root/main_scene/game_space');
	_enemy = get_node('/root/main_scene/game_space/enemy');
	_enemy_ship_parts = get_node('./enemy_ship_parts')

func activate_upgrade_phase():
	var swappable_ship_parts = []

	for child in _main_scene.get_children_in_groups(_game_space, ['swappable_ship_part'], true):
		swappable_ship_parts.append([child.global_position.x, child])

	swappable_ship_parts.sort()
	var ordered_ship_parts = []

	for part in swappable_ship_parts:
		ordered_ship_parts.append(part[1]);

	_enemy_ship_parts.global_position = _enemy.global_position
	var avg_local_pos = Vector2.ZERO;
	var upgrade_options = []

	for part in ordered_ship_parts:
		var upgrade_option = _main_scene.create_node(upgrade_prefab_path, _enemy_ship_parts);
		upgrade_option.global_position = part.global_position;
		var upgrade_sprite = part.get_node('./sprite');
		upgrade_sprite.reparent(upgrade_option);
		avg_local_pos += upgrade_option.global_position - _enemy.global_position;

		upgrade_options.append(upgrade_option);
	
	avg_local_pos = avg_local_pos / len(ordered_ship_parts)

	for option in upgrade_options:
		option.position = option.position - avg_local_pos;
	_enemy_ship_parts.global_position = _enemy_ship_parts.global_position + avg_local_pos;

	_enemy_ship_parts.animation_len_secs = animation_len_secs;
	_enemy_ship_parts_callback = []
	_enemy_ship_parts_callback.append(_enemy_ship_parts.get_path());
	_enemy_ship_parts.set_lerp_to_pos(Vector2(_center.global_position.x, _enemy_ship_parts.global_position.y), _main_scene.soft_curve, self);

func finish_lerp_to_pos(node):
	var _potential_seperate_ship_parts = false;

	if len(_enemy_ship_parts_callback) > 0:
		_potential_seperate_ship_parts = true;

	_enemy_ship_parts_callback.erase(node.get_path());
	_parts_callback.erase(node.get_path());

	if _potential_seperate_ship_parts and (len(_enemy_ship_parts_callback) == 0):
		_seperate_ship_parts()

func _seperate_ship_parts():
	for child in _enemy_ship_parts.get_children():
		child.animation_len_secs = animation_len_secs;
		_parts_callback = [];
		_parts_callback.append(child.get_path());
		var pos = _enemy_ship_parts.global_position + child.position * 1.2
		print(pos);
		child.set_lerp_to_pos(pos, _main_scene.soft_curve, self)

