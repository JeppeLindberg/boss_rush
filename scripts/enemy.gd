extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

@export var shield_size_5_path: String
@export var shield_size_1_path: String

var _ui_enemy_health_bar: Node2D
var _main_scene: Node2D
var _game_space: Node2D
var _special_effects: Node2D

var health: int
var shield: int
var _go_to_upgrade_phase_time: float = -1

var _old_pos: Vector2
var _target_pos: Vector2
var _move_time_begin: float
@export var animation_len_secs: float = 0.15;
var waiting_for_finish_animation: bool = false;


func make_ready():
	_ui_enemy_health_bar = get_node('/root/main_scene/ui/enemy_health_bar');
	_main_scene = get_node('/root/main_scene');
	_game_space = get_node('/root/main_scene/game_space');
	_special_effects = get_node('/root/main_scene/special_effects');

	shield = 0;

	for child in get_children():
		child.make_ready();
		if child.is_in_group('cockpit'):
			shield += child.shield;
	
	var health_modifier = -2;
	if _game_space.current_level == 5:
		health_modifier = 0;

	health = len(_main_scene.get_children_in_groups(self, ['damageable_enemy_ship_part'], true)) + health_modifier;
	_ui_enemy_health_bar.set_max_health(health, shield);

	if _game_space.current_level == 5:
		shield -= 1;
		_ui_enemy_health_bar.set_health(health, shield);

func _process(_delta):
	if _go_to_upgrade_phase_time != -1 and _main_scene.curr_secs() > _go_to_upgrade_phase_time:
		_go_to_upgrade_phase_time = -1;
		_game_space.go_to_upgrade_phase();
		
	if waiting_for_finish_animation:
		var animation_progress = min((_main_scene.curr_secs() - _move_time_begin) * (1.0 / animation_len_secs), 1);
		global_position = _old_pos.lerp(_target_pos, _main_scene.soft_curve.sample(animation_progress));

		if (animation_progress == 1) and waiting_for_finish_animation:
			for child in _main_scene.get_children_in_groups(self, ['has_warning_auto_trigger'], true):
				child.warning_trigger();
				
			waiting_for_finish_animation = false;

func has_shield():
	return shield > 0;

func _rangers_activate_shield():
	shield = 1;
	_ui_enemy_health_bar.set_health(health, shield);
	var parts = _main_scene.get_children_in_groups(self, ['damageable_enemy_ship_part'], true);

	for part in parts:
		var shield_node = _main_scene.create_node(shield_size_1_path, part);
		var pivot = part.get_node_or_null('./pivot/');
		if pivot != null:
			shield_node.position = pivot.position;
		else:
			shield_node.position = Vector2.ZERO;

func activate_shield():
	if _game_space.current_level == 5:
		_rangers_activate_shield();
		return;

	if shield > 0:
		for child in get_children():
			if child.is_in_group('cockpit'):
				var shield_node = _main_scene.create_node(shield_size_5_path, child);
				shield_node.position = Vector2.ZERO;

func _rangers_deactivate_shield():
	var shields = _main_scene.get_children_in_groups(self, ['shield'], true);

	for s in shields:
		s.queue_free();	

	var parts = _main_scene.get_children_in_groups(self, ['damageable_enemy_ship_part'], true);
	for part in parts:
		if part.name == 'pink_ranger':
			part.shield_deactivated();
	
func deactivate_shield():
	if shield == 0:
		if _game_space.current_level == 5:
			_rangers_deactivate_shield();
			return;

		for child in get_children():
			if child.is_in_group('cockpit'):
				for cchild in child.get_children():
					if cchild.name == 'shield':
						cchild.queue_free();
	
func move(vec):
	_move_time_begin = _main_scene.curr_secs()
	_old_pos = global_position;
	_target_pos = global_position + vec * _global_vars.GRID_SIZE_X;
	waiting_for_finish_animation = true;

func take_damage():
	print('enemy take damage');
	if shield > 0:
		shield -= 1

		if shield == 0:
			deactivate_shield();
	else:
		health -= 1

	_ui_enemy_health_bar.set_health(health, shield);

	if health == 0:
		var _enemy_ship_parts = _main_scene.get_children_in_groups(self, ['enemy_ship_part'], true);

		for ship_part in _enemy_ship_parts:
			_special_effects.multi_explosion(ship_part.global_position);

		_special_effects.screen_shake();

		_go_to_upgrade_phase_time = _main_scene.curr_secs() + _special_effects.multi_explosion_delay * len(_enemy_ship_parts) * 2;

		_game_space.enemy_dead();
