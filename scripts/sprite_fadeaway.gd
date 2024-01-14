extends Node2D

@export var fading_sprite_path: String

var _main_scene: Node2D
var _outline_manager: Node2D

var _result = []

func _ready():
	_main_scene = get_node('/root/main_scene');
	_outline_manager = get_node('/root/main_scene/outline_manager');

func _get_children_recursive(node):
	_result = []

	_get_children_recursive_helper(node)

	return _result;

func _get_children_recursive_helper(node):
	for child in node.get_children():
		if child.is_queued_for_deletion():
			continue
		
		if child.name == 'outline_sprite' or child.name == 'flame_sprite':
			child.queue_free()
		else:
			_result.append(child)
			_get_children_recursive_helper(child)


func destroy(node):
	if node.is_queued_for_deletion():
		return;

	for child in _get_children_recursive(node):
		if child is Sprite2D:
			if child.name != 'outline_sprite':
				var fading_sprite = _main_scene.create_node(fading_sprite_path, self)
				fading_sprite.global_position = child.global_position
				child.reparent(fading_sprite)
		
	node.queue_free();

