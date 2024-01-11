extends Node2D

var _game_space: Node2D
var _main_scene: Node2D

@export var player_upgrade_part_path: String
@export var texture_destroyed: Texture2D
@export var rocket_path: String

var _sprite: Sprite2D
var _shoot_countdown: Label

var auto_trigger_order = 0;
var swappable: bool



func _ready():
	add_to_group('damageable_enemy_ship_part');
	add_to_group('has_auto_trigger');
	add_to_group('enemy_ship_part');
	swappable = true;
	_sprite = get_node('./sprite');
	_main_scene = get_node('/root/main_scene')
	_game_space = get_node('/root/main_scene/game_space')
	_shoot_countdown = get_node('./shoot_countdown/label')

func trigger():
	var countdown_integer = int(_shoot_countdown.text);
	countdown_integer -= 1;

	if countdown_integer == 0:
		spawn_rocket();
		countdown_integer += 4;
	
	_shoot_countdown.text = str(countdown_integer);

	_game_space.finish_trigger(self);

func spawn_rocket():
	var rocket = _main_scene.create_node(rocket_path, _game_space);
	rocket.global_position = global_position;

func take_damage():
	_sprite.texture = texture_destroyed;
	swappable = false;
	remove_from_group('damageable_enemy_ship_part')
	remove_from_group('has_auto_trigger');
	_shoot_countdown.queue_free();
