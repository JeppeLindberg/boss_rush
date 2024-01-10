extends Node2D

var _main_scene: Node2D
var _enemy: Node2D
var _upgrades: Node2D

var current_trigger = -1;
var current_phase = 'battle';
var _has_triggered = []
var _waiting_for_callback = []


func _ready():
	_main_scene = get_node('/root/main_scene');
	_upgrades = get_node('./upgrades');
	_enemy = get_node('./enemy');
	_enemy.make_ready();

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
	if current_phase == 'battle':
		_waiting_for_callback.erase(node.get_path());

func trigger_game_space():
	current_trigger = 0;
	_waiting_for_callback = [];
	_has_triggered = [];

func _cull():
	for child in _main_scene.get_children_in_groups(self, ['cullable'], true):
		child.queue_free()

func go_to_upgrade_phase():
	current_trigger = -1
	current_phase = 'upgrade'
	_cull()
	_upgrades.activate_upgrade_phase()
	
