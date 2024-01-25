extends Node2D

var _game_space: Node2D
var _main_scene: Node2D

@export var prefab_path: String
@export var rocket_path: String

@export var textures: Dictionary
var state = 'intact';
var swappable = false
var swappable_reason = 'Cannot replace your cockpit.';

var _sprite: Sprite2D
var _shoot_countdown: Label

var auto_trigger_order = 0;



func _ready():
	add_to_group('has_auto_trigger');
	add_to_group('damageable_player_ship_part');
	add_to_group('player_ship_part');
	add_to_group('cockpit');
	_sprite = get_node('./sprite');
	_main_scene = get_node('/root/main_scene')
	_game_space = get_node('/root/main_scene/game_space')
	_shoot_countdown = get_node('./shoot_countdown/label');

func set_shoot_countdown(new_countdown):
	_shoot_countdown.text = str(int(new_countdown));

func trigger():
	var countdown_integer = int(_shoot_countdown.text);
	countdown_integer -= 1;

	if countdown_integer == 0:
		spawn_rocket();
		countdown_integer += 4 + _game_space.current_level * 2;
	
	_shoot_countdown.text = str(countdown_integer);

	_game_space.finish_trigger(self);

func spawn_rocket():
	var rocket = _main_scene.create_node(rocket_path, _game_space);
	rocket.global_position = global_position;

func take_damage():
	state = 'destroyed';
	update_texture();
	
func update_texture():
	_sprite.texture = textures[state];
