extends Node2D

@export var soft_curve: Curve;
@export var linear_curve: Curve;
@export var rising_curve: Curve;
@export var ui_bounce_curve: Curve;
@export var logathrithmic_curve: Curve;
@export var warp_curve: Curve;
@export var warp_curve_2: Curve;

var _result

func _ready():
	var game_space = get_node_or_null('./game_space')
	if game_space != null:
		game_space.go_to_next_battle();

# Get all children of the node that belongs to all of the given groups
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

# Get all children of the node that belongs to all of the given groups
func _get_children_in_groups_recursive(node, groups):
	for child in node.get_children():
		var add_to_result = true;
		for group in groups:
			if not child.is_in_group(group):
				add_to_result = false;
				break
				
		if add_to_result:
			_result.append(child)

		_get_children_in_groups_recursive(child, groups)

func create_node(prefab_path, parent):
	var scene = load(prefab_path)
	var new_node = scene.instantiate()
	parent.add_child(new_node)
	return new_node

func curr_secs():
	return float(Time.get_ticks_msec()) / 1000.0;

func is_pos_overlapping_collider(collider, pos):	
	var point = PhysicsPointQueryParameters2D.new()
	point.position = pos
	point.collide_with_areas = true;

	var collision = collider.get_world_2d().direct_space_state.intersect_point(point);
	for col in collision:
		if collider.get_parent() == col['collider']:
			return(true)
	return(false)
