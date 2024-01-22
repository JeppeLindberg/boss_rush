extends Area2D

var animation_len_secs: float = 1.0;
var _clickable = false;
var _clickable_state = 'none';
var _unclickable_reason = 'Select an enemy part.';

var future_ship_part_path: String
var part_state: String
var _swappable: bool
var _swappable_reason = '';

var _collider: CollisionShape2D

var _main_scene: Node2D
var _upgrades: Node2D
var _lerp_position: Node2D
var _outline_manager: Node2D;
var _upgrade_feedback: Node2D;


func _ready():
	_main_scene = get_node('/root/main_scene')
	_upgrades = get_node('/root/main_scene/game_space/upgrades')
	_outline_manager = get_node('/root/main_scene/outline_manager')
	_upgrade_feedback = get_node('/root/main_scene/upgrade_feedback')
	_lerp_position = get_node('./lerp_position');
	_collider = get_node('./collider');
	_lerp_position.node_to_move = self;

func initialize_from_part(part):
	var upgrade_sprite = part.get_node('./sprite');
	upgrade_sprite.reparent(self);
	future_ship_part_path = part.prefab_path;
	part_state = part.state;
	_swappable = part.swappable;
	_swappable_reason = part.swappable_reason;

func create_part():
	var part = _main_scene.create_node(future_ship_part_path, self)
	part.state = part_state
	part.update_texture()

	if part.state == 'destroyed':
		part.remove_from_group('damageable_player_ship_part')

	return(part)

func update_clickable_state():
	_clickable = true;

	if _upgrades.target_upgrade_option != null:
		if _swappable:
			_clickable_state = 'yes';
			_outline_manager.set_selectable_outline(get_node('./sprite'));
		else:
			_clickable_state = 'no';
			_outline_manager.set_unselectable_outline(get_node('./sprite'));
	else:
		_clickable_state = 'choose_enemy';
		_outline_manager.clear_selectable_outline(get_node('./sprite'));

func make_unclickable():
	_clickable = false;

func set_lerp_to_pos(new_pos, curve, caller, node_to_return = null):
	_lerp_position.animation_len_secs = animation_len_secs;
	_lerp_position.set_lerp_to_pos(new_pos, curve, caller, node_to_return)

func _upgrade_this():
	if _upgrades.target_upgrade_option == null:
		return;
		
	self.get_node('./sprite').queue_free()
	var new_sprite = _upgrades.target_upgrade_option.get_node('./sprite')
	_outline_manager.clear_selectable_outline(new_sprite)
	new_sprite.reparent(self);
	new_sprite.position = Vector2.ZERO
	future_ship_part_path = _upgrades.target_upgrade_option.player_upgrade_part_path;
	part_state = _upgrades.target_upgrade_option.part_state;
	_upgrades.target_upgrade_option.queue_free();
	_upgrades.possible_replaceable_parts -= 1;

func _unhandled_input(event):
	if not _clickable:
		return;

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			if _main_scene.is_pos_overlapping_collider(_collider, event.position):
				if _clickable_state == 'yes':
					_upgrade_this()
				elif _clickable_state == 'choose_enemy':
					_upgrade_feedback.popup_text(_unclickable_reason);
				else:
					_upgrade_feedback.popup_text(_swappable_reason);
		


			

