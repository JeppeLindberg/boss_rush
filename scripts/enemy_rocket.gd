extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

var _main_scene: Node2D
var _game_space: Node2D

var auto_trigger_order = 1;

var _old_pos: Vector2
var _target_pos: Vector2
var _move_time_begin: float
@export var animation_len_secs: float = 1.0;
var _waiting_for_finish_animation: bool


func _ready():
	add_to_group('has_auto_trigger');
	add_to_group('cullable');
	_main_scene = get_node('/root/main_scene');
	_game_space = get_node('/root/main_scene/game_space');

func trigger():
	_move(Vector2.DOWN * 2);
	
func _process(_delta):
	if not _waiting_for_finish_animation:
		return;

	var prev_pos_y = global_position.y
	var animation_progress = min((_main_scene.curr_secs() - _move_time_begin) * (1.0 / animation_len_secs), 1);
	global_position = _old_pos.lerp(_target_pos, _main_scene.linear_curve.sample(animation_progress));
	var new_pos_y = global_position.y

	if (animation_progress == 1) and _waiting_for_finish_animation:
		_waiting_for_finish_animation = false;
		_game_space.finish_trigger(self);
		return;

	var player_ship_parts = _main_scene.get_children_in_groups(_main_scene, ['player_ship_part'], true);

	for player_ship_part in player_ship_parts:
		if player_ship_part.global_position.x == global_position.x:
			if new_pos_y > player_ship_part.global_position.y and player_ship_part.global_position.y >= prev_pos_y:
				_waiting_for_finish_animation = false;
				player_ship_part.take_damage();
				_game_space.finish_trigger(self);
				self.queue_free();

func _move(vec):
	_move_time_begin = _main_scene.curr_secs()
	_old_pos = global_position;
	_target_pos = global_position + vec * _global_vars.GRID_SIZE_Y;
	_waiting_for_finish_animation = true;

