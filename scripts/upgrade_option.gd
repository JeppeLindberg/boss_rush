extends Area2D

var animation_len_secs: float = 1.0;
var _clickable = false;
var _clickable_state = 'none';
var _unclickable_reason = 'none';
var _drag_from = Vector2.ZERO;
var _dragging = false
var _swappable = false
var _swappable_reason = ''

var player_upgrade_part_path: String
var part_state: String

@export var drag_arrow_path: String

var _collider: CollisionShape2D

var _main_scene: Node2D
var _special_effects: Node2D
var _upgrades: Node2D
var _lerp_position: Node2D
var _drag_node: Node2D
var _outline_manager: Node2D;
var _upgrade_feedback: Node2D;


func _ready():
	_main_scene = get_node('/root/main_scene')
	_outline_manager = get_node('/root/main_scene/outline_manager')
	_special_effects = get_node('/root/main_scene/special_effects')
	_upgrade_feedback = get_node('/root/main_scene/upgrade_feedback')
	_upgrades = get_node('/root/main_scene/game_space/upgrades')
	_lerp_position = get_node('./lerp_position');
	_collider = get_node('./collider');
	_lerp_position.node_to_move = self;

func initialize_from_part(part):
	_swappable = part.swappable;
	_swappable_reason = part.swappable_reason;
	var upgrade_sprite = part.get_node('./sprite');
	upgrade_sprite.reparent(self);

	if _swappable:
		player_upgrade_part_path = part.player_upgrade_part_path;
	
	part_state = part.state

func update_clickable_state():
	_clickable = true;

	if _upgrades.possible_replaceable_parts == 0:
		_clickable_state = 'no_more_parts';
		_outline_manager.set_unselectable_outline(get_node_or_null('sprite'));
		_unclickable_reason = 'Can only upgrade 1 part.'
		return;

	if _upgrades.target_upgrade_option == null:
		if _swappable:
			_clickable_state = 'yes';
			_outline_manager.set_selectable_outline(get_node('./sprite'));
		else:
			_clickable_state = 'no';
			_outline_manager.set_unselectable_outline(get_node('./sprite'));
	
	else:
		if _upgrades.target_upgrade_option == self:
			_clickable_state = 'yes';
			_outline_manager.set_selectable_outline(get_node('./sprite'));
		else:
			_clickable_state = 'no';
			_outline_manager.clear_selectable_outline(get_node('./sprite'));


func set_lerp_to_pos(new_pos, curve, caller, node_to_return = null):
	_lerp_position.animation_len_secs = animation_len_secs;
	_lerp_position.set_lerp_to_pos(new_pos, curve, caller, node_to_return)

func _start_dragging(drag_from):
	_upgrades.set_target_upgrade_option(self)
	_dragging = true
	_drag_from = global_position
	_drag_node = _main_scene.create_node(drag_arrow_path, _special_effects)
	_drag_node.drag(_drag_from, drag_from)

func _drag_to(drag_to):
	_drag_node.drag(_drag_from, drag_to);

func _stop_dragging():
	if _dragging == false:
		return

	_upgrades.set_target_upgrade_option(null)
	_dragging = false
	_drag_node.queue_free()

func _unhandled_input(event):
	if not _clickable:
		return;

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
			if _main_scene.is_pos_overlapping_collider(_collider, event.position):
				if _clickable_state == 'yes':
					_start_dragging(event.position)
				elif _clickable_state == 'no_more_parts':
					_upgrade_feedback.popup_text(_unclickable_reason);
				else:
					_upgrade_feedback.popup_text(_swappable_reason);

		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			_stop_dragging()

	if _dragging and (event is InputEventMouseMotion):
		_drag_to(event.position)
		


			

