extends Node2D

@export var animation_len_secs: float = 0.5

var _initial_pos: Vector2
var _bounce_pos: Vector2
var _initial_time: float
var _animating = false
var _curve: Curve

var _main_scene: Node2D


func _ready():
	_main_scene = get_node('/root/main_scene')

func _process(_delta):
	if _animating:
		var offset = min(1 ,(_main_scene.curr_secs() - _initial_time) * (1.0/animation_len_secs))
		var weight = _curve.sample(offset)
		position = _initial_pos.lerp(_bounce_pos, weight)

		if offset >= 1.0:
			_animating = false

func spawn_animate():
	_initial_pos = position;
	_bounce_pos = position + Vector2.DOWN * 2
	_initial_time = _main_scene.curr_secs()
	_curve = _main_scene.ui_bounce_curve
	_animating = true

