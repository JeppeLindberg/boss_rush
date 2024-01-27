extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

var _main_scene: Node2D
var _game_space: Node2D
var _special_effects: Node2D

var auto_trigger_order = 1;

var _old_pos: Vector2
var _target_pos: Vector2
var _move_time_begin: float
var _active_animation_len: float
@export var animation_len_secs: float = 0.3;
var _waiting_for_finish_animation: bool

var _movement_tick: int = 0;
var _movements = [1, 1, 1, 2, 1];


func _ready():
	add_to_group('has_auto_trigger');
	add_to_group('cullable');
	add_to_group('mine');
	_main_scene = get_node('/root/main_scene');
	_game_space = get_node('/root/main_scene/game_space');
	_special_effects = get_node('/root/main_scene/special_effects');

	var mines = _main_scene.get_children_in_groups(_game_space, ['mine'], true);

	var enemy_ship_parts = _main_scene.get_children_in_groups(_game_space, ['enemy_ship_part'], true);
	enemy_ship_parts.shuffle();
	
	for part in enemy_ship_parts:
		var target_pos = part.global_position + Vector2.DOWN * 4 * _global_vars.GRID_SIZE_Y
		if not (target_pos in mines.map(_get_global_pos)):
			global_position = target_pos;
			break;

func _get_global_pos(a):
	return a.global_position;

func trigger():
	_active_animation_len = animation_len_secs * _movements[_movement_tick]
	_move(Vector2.UP * _movements[_movement_tick]);
	_movement_tick += 1;
	if _movement_tick >= _movements.size():
		_movement_tick = _movements.size() - 1;

func _process(_delta):
	if not _waiting_for_finish_animation:
		return;

	var prev_pos_y = global_position.y
	var animation_progress = min((_main_scene.curr_secs() - _move_time_begin) * (1.0 / _active_animation_len), 1);
	global_position = _old_pos.lerp(_target_pos, _main_scene.linear_curve.sample(animation_progress));
	var new_pos_y = global_position.y

	if (animation_progress == 1) and _waiting_for_finish_animation:
		_waiting_for_finish_animation = false;
		_game_space.finish_trigger(self);
		return;

	var enemy_ship_parts = _main_scene.get_children_in_groups(_game_space, ['damageable_enemy_ship_part'], true);

	for enemy_ship_part in enemy_ship_parts:
		if enemy_ship_part.global_position.x == global_position.x:
			if prev_pos_y > enemy_ship_part.global_position.y and enemy_ship_part.global_position.y >= new_pos_y:
				_special_effects.explosion(global_position);
				self.queue_free();
				_waiting_for_finish_animation = false;
				enemy_ship_part.take_damage();
				_game_space.finish_trigger(self);
				break;
				
func _move(vec):
	_move_time_begin = _main_scene.curr_secs()
	_old_pos = global_position;
	_target_pos = global_position + vec * _global_vars.GRID_SIZE_Y;
	_waiting_for_finish_animation = true;

	

