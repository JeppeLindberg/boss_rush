extends Node2D

@export var textures: Dictionary
var state = 'intact';

var _sprite: Sprite2D
var _enemy: Node2D
var swappable = false


func make_ready():
	_sprite = get_node('./sprite');
	_enemy = get_parent();
	add_to_group('damageable_enemy_ship_part');
	add_to_group('enemy_ship_part');
	add_to_group('cockpit');

func take_damage():
	state = 'destroyed';
	update_texture();
	remove_from_group('damageable_enemy_ship_part');
	_enemy.take_damage();

func update_texture():
	_sprite.texture = textures[state];