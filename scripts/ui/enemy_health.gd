extends Node2D

@export var health_texture: Texture;
@export var missing_health_texture: Texture;
@export var shield_texture: Texture;
@export var missing_shield_texture: Texture;

var _main_scene: Node2D

var _max_health = 0;
var _max_shield = 0;

func _ready():
	_main_scene = get_node('/root/main_scene');


func set_max_health(new_max_health, new_max_shield = 0):
	var index = 0;
	var avg_pos = Vector2.ZERO;
	var no_visible = 0

	_max_health = new_max_health;
	_max_shield = new_max_shield;

	for child in get_children():
		if index < new_max_health:
			child.texture = health_texture
			child.modulate.a = 1.0
			no_visible += 1;
			avg_pos += child.position
		elif index < new_max_health + new_max_shield:
			child.texture = shield_texture
			child.modulate.a = 1.0
			no_visible += 1;
			avg_pos += child.position
		else:
			child.modulate.a = 0.0

		index += 1;
	
	if no_visible > 0:
		avg_pos = avg_pos / no_visible

		for child in get_children():
			child.position -= avg_pos;

func set_health(new_health, new_shield = 0):
	var index = 0;

	for child in get_children():
		if index < _max_health:
			child.texture = missing_health_texture
		elif index < _max_health + _max_shield:
			child.texture = missing_shield_texture

		index += 1;

	index = 0;

	for child in get_children():
		if index < new_health:
			child.texture = health_texture
		elif _max_health <= index and index < _max_health + new_shield:
			child.texture = shield_texture;

		index += 1;

