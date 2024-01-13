extends Node2D

var status = 'inactive';
var progress = -1;

@export var animation_len_secs: float = 1.0;

var _main_scene: Node2D
var _center_top: Node2D
var _center_bottom: Node2D
var _player_pos: Node2D
var _enemy_pos: Node2D

var _dialog_node: Node2D
var _enemy_cockpit: Node2D
var _enemy: Node2D
var _player_cockpit: Node2D
var _player: Node2D

var _from_pos: Vector2
var _target_pos: Vector2
var _animation_node: Node2D
var _waiting_for_finish_animation: bool
var _animation_time_start: float
var _animation_curve: Curve

func _ready():
	_main_scene = get_node('/root/main_scene')
	_center_bottom = get_node('/root/main_scene/center_bottom')
	_center_top = get_node('/root/main_scene/center_top')
	_player_pos = get_node('/root/main_scene/player_pos')
	_enemy_pos = get_node('/root/main_scene/enemy_pos')

func start_dialog(dialog_index):
	progress = -1;
	status = 'active';
	_dialog_node = get_node('./dialog_' + str(dialog_index));

	_enemy = get_node('/root/main_scene/game_space/enemy');
	_enemy_cockpit = _main_scene.get_children_in_groups(_enemy, ['enemy_ship_part', 'cockpit'], true)[0];
	_player = get_node('/root/main_scene/game_space/player');
	_player_cockpit = _main_scene.get_children_in_groups(_player, ['player_ship_part', 'cockpit'], true)[0];

	_enemy.global_position = _center_top.global_position + Vector2.UP * 15.0

	progress_dialog()

func _process(_delta):
	if _waiting_for_finish_animation:
		var animation_progress = min((_main_scene.curr_secs() - _animation_time_start) * (1.0 / animation_len_secs), 1);
		_animation_node.global_position = _from_pos.lerp(_target_pos, _animation_curve.sample(animation_progress));

		if (animation_progress == 1) and _waiting_for_finish_animation:
			_waiting_for_finish_animation = false;
			progress_dialog()

func progress_dialog():
	progress += 1;
	var current_programme = _dialog_node.programme[progress]

	if current_programme['type'] == 'player_set_pos_bottom':		
		_player.global_position = _center_bottom.global_position + Vector2.DOWN * 15.0
		progress_dialog()
		return;

	if current_programme['type'] == 'player_move_into_frame':		
		_from_pos = _player.global_position
		_target_pos = _player_pos.global_position
		_animation_node = _player
		_waiting_for_finish_animation = true
		_animation_time_start = _main_scene.curr_secs()
		_animation_curve = _main_scene.linear_curve
		return;

	if current_programme['type'] == 'enemy_move_into_frame':		
		_from_pos = _enemy.global_position
		_target_pos = _enemy_pos.global_position
		_animation_node = _enemy
		_waiting_for_finish_animation = true
		_animation_time_start = _main_scene.curr_secs()
		_animation_curve = _main_scene.linear_curve
		return;
	




