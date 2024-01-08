extends Node2D

@export var soft_curve: Curve;
@export var linear_curve: Curve;

var _result

# Get all children of the node that belongs to one or more of the the given groups
func get_children_in_groups(node, groups, recursive = false):
	_result = []

	if recursive:
		_get_children_in_groups_recursive(node, groups)
		return _result

	for child in node.get_children():
		for group in groups:				
			if child.is_in_group(group):
				_result.append(child)
				break

	return _result

# Get all children of the node that belongs to one or more of the the given groups
func _get_children_in_groups_recursive(node, groups):
	for child in node.get_children():
		for group in groups:				
			if child.is_in_group(group):
				_result.append(child)
				break
		_get_children_in_groups_recursive(child, groups)

func create_node(prefab_path, parent):
	var scene = load(prefab_path)
	var new_node = scene.instantiate()
	parent.add_child(new_node)
	return new_node

func curr_secs():
	return float(Time.get_ticks_msec()) / 1000.0;