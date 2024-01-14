extends Node2D

@export var player_upgrade_part_path: String
@export var textures: Dictionary

var state = 'intact';

var _enemy: Node2D
var _sprite: Sprite2D
var swappable: bool = true
var swappable_reason = 'Always';



func make_ready():
	_sprite = get_node('./sprite');
	_enemy = get_parent();
	swappable = true
	add_to_group('damageable_enemy_ship_part');
	add_to_group('enemy_ship_part');

func take_damage():
	state = 'destroyed';
	update_texture();
	remove_from_group('damageable_enemy_ship_part');
	_enemy.take_damage();

func update_texture():
	_sprite.texture = textures[state];
	
