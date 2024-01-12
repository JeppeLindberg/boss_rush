extends Area2D

var animation_len_secs: float = 1.0;
var _clickable = false;
var _drag_from = Vector2.ZERO;
var _dragging = false
var _swappable = false

var player_upgrade_part_path: String
var part_state: String

@export var drag_arrow_path: String

var _collider: CollisionShape2D

var _main_scene: Node2D
var _special_effects: Node2D
var _upgrades: Node2D
var _lerp_position: Node2D
var _drag_node: Node2D


func _ready():
	_main_scene = get_node('/root/main_scene')
	_special_effects = get_node('/root/main_scene/special_effects')
	_upgrades = get_node('/root/main_scene/game_space/upgrades')
	_lerp_position = get_node('./lerp_position');
	_collider = get_node('./collider');
	_lerp_position.node_to_move = self;

func initialize_from_part(part):
	_swappable = part.swappable;
	var upgrade_sprite = part.get_node('./sprite');
	upgrade_sprite.reparent(self);

	if _swappable:
		player_upgrade_part_path = part.player_upgrade_part_path;
	
	part_state = part.state

func make_clickable():
	_clickable = true;

func set_lerp_to_pos(new_pos, curve, caller, node_to_return = null):
	_lerp_position.animation_len_secs = animation_len_secs;
	_lerp_position.set_lerp_to_pos(new_pos, curve, caller, node_to_return)

func _start_dragging(drag_from):
	_upgrades.target_upgrade_option = self
	_dragging = true
	_drag_from = global_position
	_drag_node = _main_scene.create_node(drag_arrow_path, _special_effects)
	_drag_node.drag(_drag_from, drag_from)

func _drag_to(drag_to):
	_drag_node.drag(_drag_from, drag_to);

func _stop_dragging():
	if _dragging == false:
		return

	_upgrades.target_upgrade_option = null
	_dragging = false
	_drag_node.queue_free()

func _unhandled_input(event):
	if not _clickable:
		return;

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
			if _main_scene.is_pos_overlapping_collider(_collider, event.position):
				_start_dragging(event.position)

		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			_stop_dragging()

	if _dragging and (event is InputEventMouseMotion):
		_drag_to(event.position)
		


			

