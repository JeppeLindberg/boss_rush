extends Node2D

var _main_scene: Node2D

var current_trigger = -1;


func _ready():
	_main_scene = get_node('/root/main_scene');

func trigger_game_space():
	current_trigger = 0;

	while (current_trigger < 5):
		for child in _main_scene.get_children_in_groups(self, ['has_auto_trigger'], true):
			if child.auto_trigger_order == current_trigger:
				child.trigger();

		current_trigger += 1;
	
	current_trigger = -1;

	