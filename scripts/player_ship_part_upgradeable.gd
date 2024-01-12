extends Area2D

var animation_len_secs: float = 1.0;
var _clickable = false;

var future_ship_part_path: String
var part_state: String

var _collider: CollisionShape2D

var _main_scene: Node2D
var _upgrades: Node2D
var _lerp_position: Node2D


func _ready():
	_main_scene = get_node('/root/main_scene')
	_upgrades = get_node('/root/main_scene/game_space/upgrades')
	_lerp_position = get_node('./lerp_position');
	_collider = get_node('./collider');
	_lerp_position.node_to_move = self;

func initialize_from_part(part):
	var upgrade_sprite = part.get_node('./sprite');
	upgrade_sprite.reparent(self);
	future_ship_part_path = part.prefab_path;
	part_state = part.state;

func create_part():
	var part = _main_scene.create_node(future_ship_part_path, self)
	part.state = part_state
	print('state ' + part.state)
	part.update_texture()
	return(part)

func make_clickable():
	_clickable = true;

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
	new_sprite.reparent(self);
	new_sprite.position = Vector2.ZERO
	future_ship_part_path = _upgrades.target_upgrade_option.player_upgrade_part_path;
	part_state = _upgrades.target_upgrade_option.part_state;
	_upgrades.target_upgrade_option.queue_free();

func _unhandled_input(event):
	if not _clickable:
		return;

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			if _main_scene.is_pos_overlapping_collider(_collider, event.position):
				_upgrade_this()
		


			

