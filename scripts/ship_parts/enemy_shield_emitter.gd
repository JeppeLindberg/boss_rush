extends Node2D

var _game_space: Node2D
var _main_scene: Node2D
var _emit_countdown: Node2D
var _emit_countdown_label: Label

@export var emit_cooldown: int = 4
@export var player_upgrade_part_path: String
@export var textures: Dictionary

var state = 'intact';

var _enemy: Node2D
var _sprite: Sprite2D
var swappable: bool = true
var swappable_reason = 'Always';
var auto_trigger_order = 3;



func make_ready():
	_sprite = get_node('./sprite');
	_enemy = get_parent();
	swappable = true
	add_to_group('damageable_enemy_ship_part');
	add_to_group('has_auto_trigger');
	add_to_group('enemy_ship_part');

	_sprite = get_node('./sprite');
	_main_scene = get_node('/root/main_scene')
	_game_space = get_node('/root/main_scene/game_space')
	_emit_countdown_label = get_node('./emit_countdown/label')
	_emit_countdown = get_node('./emit_countdown')

	_emit_countdown_label.text = str(99999);
	_emit_countdown.modulate.a = 0.0

func trigger():
	var countdown_integer = int(_emit_countdown_label.text);
	if countdown_integer > 100:
		_emit_countdown.modulate.a = 0.0
	else:
		_emit_countdown.modulate.a = 1.0

	countdown_integer -= 1;

	if countdown_integer == 0:
		emit_shield();
		countdown_integer += 99999;
		_emit_countdown.modulate.a = 0.0;
	
	_emit_countdown_label.text = str(countdown_integer);

	_game_space.finish_trigger(self);

func emit_shield():
	_enemy.activate_shield()

func shield_deactivated():
	_emit_countdown_label.text = str(emit_cooldown);

func take_damage():
	if not _enemy.has_shield():
		state = 'destroyed';
		swappable = false;
		swappable_reason = 'Cannot take broken part.';
		update_texture();
		remove_from_group('damageable_enemy_ship_part');
		remove_from_group('has_auto_trigger');
		_emit_countdown.queue_free();
		
	_enemy.take_damage();

func update_texture():
	_sprite.texture = textures[state];
	
