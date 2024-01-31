extends Node2D

@export var shield: int;
@export var move_delay: int;
@export var initial_move_delay: int;

@export var textures: Dictionary
var state = 'intact';

var _sprite: Sprite2D
var _enemy: Node2D
var _move_countdown: Node2D
var _move_countdown_label: Label
var _move_countdown_pip: Sprite2D
var _game_space: Node2D
var _main_scene: Node2D

var swappable = false
var swappable_reason = 'Cannot take cockpit.';

var auto_trigger_order = 2;
var _waiting_for_move = false;


func make_ready():
	_sprite = get_node('./sprite');
	_move_countdown = get_node('./move_countdown')
	_move_countdown_label = get_node('./move_countdown/label')
	_move_countdown_pip = get_node('./move_countdown/pip')
	_game_space = get_node('/root/main_scene/game_space')
	_main_scene = get_node('/root/main_scene')
	_enemy = get_parent();
	add_to_group('damageable_enemy_ship_part');
	add_to_group('enemy_ship_part');
	add_to_group('cockpit');
	if move_delay != 0:
		add_to_group('has_auto_trigger')
		_move_countdown.modulate.a = 1.0;
	else:
		_move_countdown.modulate.a = 0.0;

	if initial_move_delay != 0:
		_move_countdown_label.text = str(initial_move_delay);
	else:
		_move_countdown_label.text = str(move_delay);
	_plan_next_move();

func _process(_delta):
	if _waiting_for_move:
		if _enemy.waiting_for_finish_animation == false:
			_waiting_for_move = false;
			_game_space.finish_trigger(self);
			_plan_next_move()

func trigger():
	var countdown_integer = int(_move_countdown_label.text);
	countdown_integer -= 1;

	if countdown_integer == 0:
		_move();
		countdown_integer += move_delay;
	else:
		for child in _main_scene.get_children_in_groups(_enemy, ['has_warning_auto_trigger'], true):
			child.warning_trigger();
	
	_move_countdown_label.text = str(countdown_integer);

	if not _waiting_for_move:
		_game_space.finish_trigger(self);

func _move():
	_waiting_for_move = true;

	var vec = Vector2.RIGHT;

	if _move_countdown_pip.scale.x < 0:
		vec = Vector2.LEFT;

	_enemy.move(vec);

func _plan_next_move():
	var player_cockpit = _main_scene.get_children_in_groups(_game_space, ['player_ship_part', 'cockpit'], true)[0];

	var from_locs_x = [global_position.x - 30, global_position.x - 10, global_position.x + 10, global_position.x + 30];
	var from_loc_x = from_locs_x.pick_random();

	if from_loc_x > player_cockpit.global_position.x:
		_move_countdown_pip.position.x = -1;
		_move_countdown_pip.scale.x = -1;
	else:
		_move_countdown_pip.position.x = 0;
		_move_countdown_pip.scale.x = 1;

func take_damage():
	if not _enemy.has_shield():
		state = 'destroyed';
		update_texture();
		remove_from_group('has_auto_trigger');
		_move_countdown.queue_free();
		remove_from_group('damageable_enemy_ship_part');
		
	_enemy.take_damage();

func update_texture():
	_sprite.texture = textures[state];
