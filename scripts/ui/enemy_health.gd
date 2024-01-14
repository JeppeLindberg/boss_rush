extends Node2D

@export var health_texture: Texture;
@export var missing_health_texture: Texture;

var _main_scene: Node2D


func _ready():
	_main_scene = get_node('/root/main_scene');


func set_max_health(new_max_health):
	var index = 0;
	var avg_pos = Vector2.ZERO;
	var no_visible = 0

	for child in get_children():
		child.texture = health_texture
		if index < new_max_health:
			child.modulate.a = 1.0
			no_visible += 1;
			avg_pos = child.position
		else:
			child.modulate.a = 0.0

		index += 1;
	
	if no_visible > 0:
		avg_pos = avg_pos / no_visible

		for child in get_children():
			child.position -= avg_pos;


func set_health(new_health):
	var index = 0;
	for child in get_children():
		if index < new_health:
			child.texture = health_texture
		else:
			child.texture = missing_health_texture;
		index += 1;

