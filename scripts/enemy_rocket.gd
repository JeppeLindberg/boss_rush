extends Node2D

var _global_vars := preload("res://scripts/library/global_vars.gd").new()

var _main_scene: Node2D

var auto_trigger_order = 1;


func _ready():
	add_to_group('has_auto_trigger');
	_main_scene = get_node('/root/main_scene');

func trigger():
	move(Vector2.DOWN * 3);
	
func move(vec):
	var prev_pos_y = global_position.y

	global_position = global_position + vec * _global_vars.GRID_SIZE_Y;

	var new_pos_y = global_position.y

	var enemy_ship_parts = _main_scene.get_children_in_groups(_main_scene, ['player_ship_part'], true);
	
	for enemy_ship_part in enemy_ship_parts:
		if enemy_ship_part.global_position.x == global_position.x:
			if new_pos_y > enemy_ship_part.global_position.y and enemy_ship_part.global_position.y >= prev_pos_y:
				enemy_ship_part.take_damage();
				self.queue_free();

