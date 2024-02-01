extends Area2D

@export var animation_len_secs: float = 1.0;
var _clicked_this = false;
var _colorize_screen: Node2D

var player_upgrade_part_path: String

@export var main_scene_path: String

var _main_scene: Node2D
var _collider: Node2D
var _fade_callback = []


func _ready():
	make_ready()	

func make_ready():
	_main_scene = get_node_or_null('/root/main_scene')
	if _main_scene == null or _main_scene.is_queued_for_deletion():
		_main_scene = get_node('/root/main_menu')
	_collider = get_node('./collider')
	_colorize_screen = get_node_or_null('/root/main_scene/colorize_screen')
	if _colorize_screen == null or _colorize_screen.is_queued_for_deletion():
		_colorize_screen = get_node('/root/main_menu/colorize_screen')

func _go_to_designated_scene():
	make_ready();
	_colorize_screen.animation_len_secs = animation_len_secs;
	_colorize_screen.alpha_modifier = 1.0;
	_fade_callback.append(_colorize_screen.get_path());
	_colorize_screen.set_lerp_to_pos(_colorize_screen.global_position, _main_scene.rising_curve, self, _colorize_screen, 'fade_in')

func finish_lerp_to_pos(node):
	_fade_callback.erase(node.get_path());

	if len(_fade_callback) == 0:
		_main_scene.queue_free()
		_main_scene.create_node(main_scene_path, get_node('/root/'))

func _unhandled_input(event):
	if not self.visible:
		return;

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
			_clicked_this = _main_scene.is_pos_overlapping_collider(_collider, event.position)

		elif (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			if _clicked_this and _main_scene.is_pos_overlapping_collider(_collider, event.position):
				if animation_len_secs < 0.0:
					_main_scene.queue_free()
					_main_scene.create_node(main_scene_path, get_node('/root/'))
					return;
				if len(_fade_callback) == 0:
					_go_to_designated_scene()

			

