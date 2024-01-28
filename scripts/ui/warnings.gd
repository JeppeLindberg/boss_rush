extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

@export var warning_red_path: String

var _main_scene: Node2D

var _warnings: Array


func _ready():
	_main_scene = get_node('/root/main_scene')

func add_warning(source_node, source_pos, relative_delta):
	var new_warning = _main_scene.create_node(warning_red_path, self)
	new_warning.position = source_pos + Vector2(relative_delta.x * _global_vars.GRID_SIZE_X, relative_delta.y * _global_vars.GRID_SIZE_Y);
	_warnings.append([source_node.get_path(), new_warning])

func clear_warnings(source_node):
	for i in range(len(_warnings) - 1, -1, -1):
		if _warnings[i][0] == source_node.get_path():
			_warnings[i][1].queue_free()
			_warnings.remove_at(i)

func clear_all_warnings():
	for i in range(len(_warnings) - 1, -1, -1):
		_warnings[i][1].queue_free()
		_warnings.remove_at(i)
