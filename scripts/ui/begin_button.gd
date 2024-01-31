extends Area2D

var animation_len_secs: float = 1.0;
var _clicked_this = false;

var player_upgrade_part_path: String

@export var main_scene_path: String

var _main_scene: Node2D
var _collider: Node2D


func _ready():
	_main_scene = get_node('/root/main_menu')
	_collider = get_node('./collider')

func _unhandled_input(event):
	if not self.visible:
		return;

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
			_clicked_this = _main_scene.is_pos_overlapping_collider(_collider, event.position)

		elif (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			if _clicked_this and _main_scene.is_pos_overlapping_collider(_collider, event.position):
				_main_scene.queue_free()
				_main_scene.create_node(main_scene_path, get_node('/root/'))

			

