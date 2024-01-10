extends Node2D

var _old_pos: Vector2
var _target_pos: Vector2
var _move_time_begin: float
var animation_len_secs: float = 1.0;
var _waiting_for_finish_animation: bool
var _curve: Curve

var _caller: Node2D
var _main_scene: Node2D

func _ready():
    _main_scene = get_node('/root/main_scene')

func _process(_delta):
    if not _waiting_for_finish_animation:
        return;

    var animation_progress = min((_main_scene.curr_secs() - _move_time_begin) * (1.0 / animation_len_secs), 1);
    global_position = _old_pos.lerp(_target_pos, _curve.sample(animation_progress));

    if (animation_progress == 1) and _waiting_for_finish_animation:
        _waiting_for_finish_animation = false;
        _caller.finish_lerp_to_pos(self);

func set_lerp_to_pos(new_pos, curve, caller):
    _move_time_begin = _main_scene.curr_secs()
    _old_pos = global_position;	
    _target_pos = new_pos;
    _waiting_for_finish_animation = true;
    _caller = caller;
    _curve = curve

