extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

@export var _burning_path: String

var _game_space: Node2D
var _main_scene: Node2D
var _special_effects: Node2D
var _left_player_limit: Node2D
var _right_player_limit: Node2D
var _audio: Node2D

var _old_pos: Vector2
var _target_pos: Vector2
var _move_time_begin: float
@export var animation_len_secs: float = 1.0;
var _waiting_for_finish_animation: bool
var _trigger_game_space_when_ready: bool
var _go_to_game_over_time: float = -1

var _move_left_down: bool;
var _move_right_down: bool;
var _wait_down: bool;


func _ready():
	_game_space = get_node('/root/main_scene/game_space')
	_main_scene = get_node('/root/main_scene')
	_special_effects = get_node('/root/main_scene/special_effects')
	_left_player_limit = get_node('/root/main_scene/left_player_limit')
	_right_player_limit = get_node('/root/main_scene/right_player_limit')
	_audio = get_node('/root/main_scene/camera/audio')

	_move_left_down = false;
	_move_right_down = false;
	_wait_down = false;

func _process(_delta):
	if _go_to_game_over_time != -1 and _main_scene.curr_secs() > _go_to_game_over_time:
		_go_to_game_over_time = -1;
		_game_space.go_to_game_over();

	if _game_space.current_phase == 'battle' and _game_space.current_trigger == -1 and not _waiting_for_finish_animation:
		if _move_left_down:
			_move(Vector2.LEFT);
			_move_left_down = false;
		if _move_right_down:
			_move(Vector2.RIGHT);
			_move_right_down = false;
		if _wait_down:
			_game_space.trigger_game_space();
			_wait_down = false;

	if _waiting_for_finish_animation:
		var animation_progress = min((_main_scene.curr_secs() - _move_time_begin) * (1.0 / animation_len_secs), 1);
		global_position = _old_pos.lerp(_target_pos, _main_scene.soft_curve.sample(animation_progress));

		if (animation_progress == 1) and _waiting_for_finish_animation:
			_waiting_for_finish_animation = false;
			if _trigger_game_space_when_ready:
				_trigger_game_space_when_ready = false;
				_game_space.trigger_game_space();

# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("move_left"):
			_move_left_down = true;
		if event.is_action_released("move_left"):
			_move_left_down = false;

		if event.is_action_pressed("move_right"):
			_move_right_down = true;
		if event.is_action_released("move_right"):
			_move_right_down = false;

		if event.is_action_pressed("wait"):
			_wait_down = true;
		if event.is_action_released("wait"):
			_wait_down = false;

		if event.is_action_pressed("test"):
			_special_effects.screen_shake();
	
func _move(vec):
	var delta_vec = vec * _global_vars.GRID_SIZE_X;

	for child in get_children():
		if child.global_position.x + delta_vec.x < _left_player_limit.global_position.x:
			_audio.play_cant_do_that_sfx();
			return;
		if child.global_position.x + delta_vec.x > _right_player_limit.global_position.x:
			_audio.play_cant_do_that_sfx();
			return;

	_audio.play_move_sfx();
	_move_time_begin = _main_scene.curr_secs()
	_old_pos = global_position;
	_target_pos = global_position + delta_vec;
	_trigger_game_space_when_ready = true;
	_waiting_for_finish_animation = true;

func trigger_ship_parts():
	for child in get_children():
		child.trigger()

func after_take_damage():
	if _game_space.current_level != 1:
		var burns = _main_scene.get_children_in_groups(self, ['burn'], true);
		
		for child in burns:
			child.queue_free();

		var parts = _main_scene.get_children_in_groups(self, ['damageable_player_ship_part'], false);

		if len(parts) > 1:
			for part in parts:
				if part.is_in_group('cockpit'):
					parts.erase(part);
					break;
		else:
			_audio.play_low_health_sfx();
		
		var part = parts.pick_random();

		var burning = _main_scene.create_node(_burning_path, part);
		burning.position = Vector2.ZERO;

func die():	
	_audio.play_character_death_sfx();

	var _player_ship_parts = _main_scene.get_children_in_groups(self, ['player_ship_part'], true);

	for ship_part in _player_ship_parts:
		_special_effects.multi_explosion(ship_part.global_position);

	_special_effects.screen_shake();

	_go_to_game_over_time = _main_scene.curr_secs() + _special_effects.multi_explosion_delay * len(_player_ship_parts) * 2;

