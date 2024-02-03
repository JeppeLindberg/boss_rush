extends Node2D

var _old_pos: Vector2
var _target_pos: Vector2
var _move_time_begin: float
var animation_len_secs: float = 1.0;
var alpha_modifier: float = 1.0;
var _waiting_for_finish_animation: bool
var _curve: Curve
var _also_lerp_alpha: String

var _node_to_return: Node2D
var _caller: Node2D
var _main_scene: Node2D
var node_to_move: Node2D

func _ready():
	_main_scene = get_node_or_null('/root/main_scene')
	if _main_scene == null or _main_scene.is_queued_for_deletion():
		_main_scene = get_node('/root/main_menu')
	node_to_move = self;
	_node_to_return = self;

func _process(_delta):
	if not _waiting_for_finish_animation:
		return;

	var animation_progress = min((_main_scene.curr_secs() - _move_time_begin) * (1.0 / animation_len_secs), 1);
	node_to_move.global_position = _old_pos.lerp(_target_pos, _curve.sample(animation_progress));

	if (animation_progress == 1) and _waiting_for_finish_animation:
		_waiting_for_finish_animation = false;
		_caller.finish_lerp_to_pos(_node_to_return);
	
	if _also_lerp_alpha == 'fade_out':
		modulate.a = (1.0-_curve.sample(animation_progress))*alpha_modifier;
	if _also_lerp_alpha == 'fade_in':
		modulate.a = (_curve.sample(animation_progress))*alpha_modifier;

func set_lerp_to_pos(new_pos, curve, caller, node_to_return = null, also_lerp_alpha = ''):
	_move_time_begin = _main_scene.curr_secs()
	_old_pos = node_to_move.global_position;	
	_target_pos = new_pos;
	_waiting_for_finish_animation = true;
	_caller = caller;
	_curve = curve
	if node_to_return != null:
		_node_to_return = node_to_return
	_also_lerp_alpha = also_lerp_alpha

