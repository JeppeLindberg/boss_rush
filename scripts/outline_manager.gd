extends Node2D

@export var selectable_prefab_path: String
@export var unselectable_prefab_path: String

var _main_scene


func _ready():
	_main_scene = get_node('/root/main_scene');

func set_selectable_outline(sprite_node):
	if sprite_node == null:
		return;

	clear_selectable_outline(sprite_node)
	var new_node = _main_scene.create_node(selectable_prefab_path, sprite_node)
	new_node.name = 'outline_sprite';
	new_node.texture = sprite_node.texture
	new_node.position = Vector2.ZERO;

func set_unselectable_outline(sprite_node):
	if sprite_node == null:
		return;

	clear_selectable_outline(sprite_node)
	var new_node = _main_scene.create_node(unselectable_prefab_path, sprite_node)
	new_node.name = 'outline_sprite';
	new_node.texture = sprite_node.texture
	new_node.position = Vector2.ZERO;

func clear_selectable_outline(sprite_node):
	if sprite_node == null:
		return;

	for child in sprite_node.get_children():
		child.queue_free()
