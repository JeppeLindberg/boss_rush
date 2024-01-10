extends Node2D

@export var texture_destroyed: Texture2D

var _sprite: Sprite2D
var _enemy: Node2D
var swappable = false


func _ready():
	_sprite = get_node('./sprite');
	_enemy = get_parent();
	add_to_group('enemy_ship_part');
	add_to_group('swappable_ship_part');

func take_damage():
	_sprite.texture = texture_destroyed;
	remove_from_group('enemy_ship_part');
	_enemy.take_damage();
