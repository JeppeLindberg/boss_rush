extends Sprite2D

@export var frames_per_second: float = 1.0
@export var self_destroy: bool = false
@export var random_rotation: bool = false
@export var frames: Array[Texture]
@export var override_button: String = ''

var _main_scene: Node2D

var _animation_begin: float
var _sprite_override: bool

func _ready():
	_main_scene = get_node('/root/main_scene')
	start_animation()

func _process(_delta):
	if _sprite_override:
		texture = frames[len(frames) - 1]
		return;

	var _animation_progress = int((_main_scene.curr_secs() - _animation_begin) * frames_per_second)

	if self_destroy and (_animation_progress > len(frames) - 1):
		queue_free();
		return;

	_animation_progress = _animation_progress % len(frames)

	texture = frames[_animation_progress]

func start_animation():
	_animation_begin = _main_scene.curr_secs()
	texture = frames[0]

	if random_rotation:
		rotation_degrees = [0.0, 90.0, 180.0, 270.0].pick_random()

func _input(event):
	if override_button == '':
		return;

	if event is InputEventKey:
		if event.is_action_pressed(override_button):
			_sprite_override = true;
		if event.is_action_released(override_button):
			_sprite_override = false;