extends Node2D

var _game_space: Node2D
var _main_scene: Node2D
var _audio: Node2D

@export var initial_shot_cooldown: int
@export var shot_cooldown: int

@export var player_upgrade_part_path: String
@export var mine_path: String

@export var textures: Dictionary
var state = 'intact';

var _sprite: Sprite2D
var _shoot_countdown: Node2D
var _shoot_countdown_label: Label
var _enemy: Node2D

var auto_trigger_order = 0;
var swappable: bool
var swappable_reason = 'Always';



func make_ready():
	add_to_group('damageable_enemy_ship_part');
	add_to_group('has_auto_trigger');
	add_to_group('enemy_ship_part');
	swappable = true;
	_enemy = get_parent();
	_sprite = get_node('./sprite');
	_main_scene = get_node('/root/main_scene')
	_game_space = get_node('/root/main_scene/game_space')
	_shoot_countdown_label = get_node('./shoot_countdown/label')
	_shoot_countdown = get_node('./shoot_countdown')
	_audio = get_node('/root/main_scene/camera/audio')

	_shoot_countdown_label.text = str(initial_shot_cooldown);

func trigger():
	var countdown_integer = int(_shoot_countdown_label.text);
	countdown_integer -= 1;

	if countdown_integer == 0:
		_spawn_mine();
		countdown_integer += shot_cooldown;
	
	_shoot_countdown_label.text = str(countdown_integer);

	_game_space.finish_trigger(self);

func _spawn_mine():
	_audio.play_mine_deploy_sfx();
	_main_scene.create_node(mine_path, _game_space);

func take_damage():
	if not _enemy.has_shield():
		state = 'destroyed';
		swappable = false;
		swappable_reason = 'Cannot take broken part.';
		update_texture();
		remove_from_group('has_auto_trigger');
		_shoot_countdown.queue_free();
		remove_from_group('damageable_enemy_ship_part');
		
	_enemy.take_damage();

func update_texture():
	_sprite.texture = textures[state];
