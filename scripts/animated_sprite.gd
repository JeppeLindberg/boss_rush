extends Sprite2D

@export var frames_per_second: float = 1.0
@export var frames: Array[Texture]

var _main_scene: Node2D

var _animation_begin: float

func _ready():
	_main_scene = get_node('/root/main_scene')

func _process(_delta):
	var _animation_progress = int((_main_scene.curr_secs() - _animation_begin) * frames_per_second)

	_animation_progress = _animation_progress % len(frames)

	texture = frames[_animation_progress]

func start_animation():
	_animation_begin = _main_scene.curr_secs()
	texture = frames[0]

