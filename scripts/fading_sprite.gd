extends Node2D

var _main_scene: Node2D
var _sprite: Node2D

@export var fade_period_secs: float = 1.0
var _time_begin: float
var _start_rotation: float
var _target_rotation: float

func _ready():
	_main_scene = get_node('/root/main_scene');
	_target_rotation = [_start_rotation - 100.0, _start_rotation + 100].pick_random()

func _lerp_float(from, to, weight):
	var diff = to - from
	return (from + (diff * weight))

func _process(delta):
	if _sprite == null:
		_time_begin = _main_scene.curr_secs() - delta
		_sprite = get_node('./sprite')
		_start_rotation = _sprite.global_rotation_degrees

	var animation_progress = min((_main_scene.curr_secs() - _time_begin) * (1.0 / fade_period_secs), 1);
	var zero = 0.0
	global_rotation_degrees = _lerp_float(zero, _target_rotation, animation_progress)
	var white = Color.WHITE
	var transparent = Color(1,1,1,0)
	modulate = white.lerp(transparent, animation_progress)

	if animation_progress >= 1.0:
		queue_free()
