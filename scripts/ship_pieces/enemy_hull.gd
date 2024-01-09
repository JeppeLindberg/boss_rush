extends Node2D

@export var texture_destroyed: Texture2D

var _sprite: Sprite2D



func _ready():
	_sprite = get_node('./sprite');
	add_to_group('enemy_ship_part');

func take_damage():
	_sprite.texture = texture_destroyed;
	remove_from_group('enemy_ship_part');
