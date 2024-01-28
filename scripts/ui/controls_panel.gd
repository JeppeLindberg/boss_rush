extends Area2D

var _hovering_this = false;

var _main_scene: Node2D
var _game_space: Node2D
var _collider: Node2D
var _moveable_panel: Node2D
var _up_arrow: Node2D
var _panel_sprite: Node2D

var _moveable_panel_initial_pos: Vector2
var _moveable_panel_moved_pos: Vector2


func _ready():
	_main_scene = get_node('/root/main_scene')
	_game_space = get_node('/root/main_scene/game_space')
	_collider = get_node('./collider')
	_moveable_panel = get_node('./moveable_panel')
	_up_arrow = get_node('./moveable_panel/up_arrow')
	_panel_sprite = get_node('./moveable_panel/panel')

	_moveable_panel_initial_pos = _moveable_panel.position
	_moveable_panel_moved_pos = _moveable_panel_initial_pos + Vector2.UP * 16

func _unhandled_input(event):
	if event is InputEventMouse:
		_hovering_this = _main_scene.is_pos_overlapping_collider(_collider, event.position)

func _process(_delta):
	self.visible = _game_space.current_phase == 'battle';

	if _hovering_this or _game_space.current_level == 1:
		_up_arrow.visible = false;
		_panel_sprite.modulate.a = 1.0
		self.modulate.a = 1.0
		_moveable_panel.position = _moveable_panel_moved_pos
	else:
		_up_arrow.visible = true;
		_panel_sprite.modulate.a = 0.0
		self.modulate.a = 0.5
		_moveable_panel.position = _moveable_panel_initial_pos


			

