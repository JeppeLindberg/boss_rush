extends Node2D

var _main_scene: Node2D

var current_trigger = -1;
var _has_triggered = []
var _waiting_for_callback = []


func _ready():
	_main_scene = get_node('/root/main_scene');

func _process(_delta):
	if current_trigger == -1:
		return;
	
	if len(_waiting_for_callback) == 0:

		for child in _main_scene.get_children_in_groups(self, ['has_auto_trigger'], true):
			if (child.auto_trigger_order == current_trigger) and not (child.get_path() in _has_triggered):
				_has_triggered.append(child.get_path());
				_waiting_for_callback.append(child.get_path());
				child.trigger();

		if len(_waiting_for_callback) == 0:
			current_trigger += 1;
	
	if current_trigger == 5:
		current_trigger = -1;

func finish_trigger(node):
	_waiting_for_callback.erase(node.get_path());

func trigger_game_space():
	current_trigger = 0;
	_waiting_for_callback = [];
	_has_triggered = [];

	
