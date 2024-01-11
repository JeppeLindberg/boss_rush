extends Node2D

@export var prefab_path: String
@export var texture_destroyed: Texture2D

var _sprite: Sprite2D


func _ready():
	add_to_group('damageable_player_ship_part');
	add_to_group('player_ship_part');
	_sprite = get_node('./sprite');

func take_damage():
	_sprite.texture = texture_destroyed;
	remove_from_group('damageable_player_ship_part');
	
