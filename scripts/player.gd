extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

var _game_space: Node2D
var _main_scene: Node2D

var _old_pos: Vector2
var _target_pos: Vector2
var _move_time_begin: float
@export var animation_len_secs: float = 1.0;
var _waiting_for_finish_animation: bool


func _ready():
	_game_space = get_node('/root/main_scene/game_space')
	_main_scene = get_node('/root/main_scene')

func _process(_delta):
	if not _waiting_for_finish_animation:
		return;

	var animation_progress = min((_main_scene.curr_secs() - _move_time_begin) * (1.0 / animation_len_secs), 1);
	global_position = _old_pos.lerp(_target_pos, _main_scene.soft_curve.sample(animation_progress));

	if (animation_progress == 1) and _waiting_for_finish_animation:
		_waiting_for_finish_animation = false;
		_game_space.trigger_game_space();

# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	if (_game_space.current_trigger != -1) or (_waiting_for_finish_animation):
		return;

	if event.is_action_pressed("move_left"):
		_move(Vector2.LEFT);
	
	if event.is_action_pressed("move_right"):
		_move(Vector2.RIGHT);	
	
func _move(vec):
	_move_time_begin = _main_scene.curr_secs()
	_old_pos = global_position;
	_target_pos = global_position + vec * _global_vars.GRID_SIZE_X;
	_waiting_for_finish_animation = true;

func trigger_ship_parts():
	for child in get_children():
		child.trigger()

