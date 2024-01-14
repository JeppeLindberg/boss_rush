extends Node2D

@export var prefab_path: String

@export var textures: Dictionary
var state = 'intact';
var swappable: bool = true
var swappable_reason = 'Always';

var _sprite: Sprite2D


func _ready():
	add_to_group('damageable_player_ship_part');
	add_to_group('player_ship_part');
	_sprite = get_node('./sprite');

func take_damage():
	state = 'destroyed';
	update_texture();
	remove_from_group('damageable_player_ship_part');

func update_texture():
	_sprite.texture = textures[state];

	
