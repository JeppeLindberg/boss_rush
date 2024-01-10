extends Node2D

@export var health_texture: Texture;
@export var missing_health_texture: Texture;

var _main_scene: Node2D


func _ready():
	_main_scene = get_node('/root/main_scene');


func set_max_health(new_max_health):
	var index = 0;
	for child in get_children():
		child.texture = health_texture
		child.visible = index < new_max_health
		index += 1;

func set_health(new_health):
	var index = 0;
	for child in get_children():
		if index < new_health:
			child.texture = health_texture
		else:
			child.texture = missing_health_texture;
		index += 1;

