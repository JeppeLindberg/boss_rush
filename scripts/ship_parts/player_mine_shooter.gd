extends Node2D

var _game_space: Node2D
var _main_scene: Node2D
var _player: Node2D
var _audio: Node2D

@export var initial_shoot_delay: int = 5
@export var shoot_delay: int = 5

@export var prefab_path: String
@export var mine_path: String

@export var textures: Dictionary
var state = 'intact';
var swappable: bool = true
var swappable_reason = 'Always';

var _sprite: Sprite2D
var _shoot_countdown: Node2D
var _shoot_countdown_label: Label

var auto_trigger_order = 0;



func _ready():
	add_to_group('has_auto_trigger');
	add_to_group('damageable_player_ship_part');
	add_to_group('player_ship_part');
	_sprite = get_node('./sprite');
	_main_scene = get_node('/root/main_scene')
	_game_space = get_node('/root/main_scene/game_space')
	_shoot_countdown = get_node('./shoot_countdown');
	_shoot_countdown_label = get_node('./shoot_countdown/label');
	_player = get_node('/root/main_scene/game_space/player');
	_audio = get_node('/root/main_scene/camera/audio')
	_shoot_countdown_label.text = str(initial_shoot_delay);

func trigger():
	var countdown_integer = int(_shoot_countdown_label.text);
	countdown_integer -= 1;

	if countdown_integer == 0:
		spawn_mine();
		countdown_integer += shoot_delay;
	
	_shoot_countdown_label.text = str(countdown_integer);

	_game_space.finish_trigger(self);

func spawn_mine():
	_audio.play_mine_deploy_sfx();
	_main_scene.create_node(mine_path, _game_space);

func take_damage():
	state = 'destroyed';
	update_texture();
	remove_from_group('has_auto_trigger');
	_shoot_countdown.queue_free();
	remove_from_group('damageable_player_ship_part');

	_player.after_take_damage();
	
func update_texture():
	_sprite.texture = textures[state];


