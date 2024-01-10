extends Node2D

@export var texture_destroyed: Texture2D

@export var swappable_ship_part_path: String;

var _enemy: Node2D
var _sprite: Sprite2D
var swappable: bool



func _ready():
	_sprite = get_node('./sprite');
	_enemy = get_parent();
	swappable = true
	add_to_group('enemy_ship_part');
	add_to_group('swappable_ship_part');

func take_damage():
	_sprite.texture = texture_destroyed;
	swappable = false
	remove_from_group('enemy_ship_part');
	_enemy.take_damage();
