extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

var _game_space: Node2D


func _ready():
	_game_space = get_node('/root/main_scene/game_space')

# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	var continue_battle = false;

	if event.is_action_pressed("move_left"):
		move(Vector2.LEFT);
		continue_battle = true;
	
	if event.is_action_pressed("move_right"):
		move(Vector2.RIGHT);
		continue_battle = true;

	if continue_battle:
		_game_space.trigger_game_space();
	
	
func move(vec):
	global_position = global_position + vec * _global_vars.GRID_SIZE_X;

func trigger_ship_parts():
	for child in get_children():
		child.trigger()

