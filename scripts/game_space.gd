extends Node2D

var _main_scene: Node2D
var _enemy: Node2D
var _upgrades: Node2D
var _garage: Node2D
var _dialog: Node2D
var _sprite_fadeaway: Node2D

var current_level = 3;
var current_trigger = -1;
var current_phase = '';
var _has_triggered = []
var _waiting_for_callback = []


func _ready():
	_main_scene = get_node('/root/main_scene');
	_garage = get_node('/root/main_scene/garage');
	_dialog = get_node('/root/main_scene/dialog');
	_sprite_fadeaway = get_node('/root/main_scene/sprite_fadeaway');
	_upgrades = get_node('./upgrades');
	_enemy = get_node('./enemy');

func _process(_delta):
	if (current_trigger == -1) or (current_phase != 'battle'):
		return;
	
	while len(_waiting_for_callback) == 0:
		for child in _main_scene.get_children_in_groups(self, ['has_auto_trigger'], true):
			if (child.auto_trigger_order == current_trigger) and not (child.get_path() in _has_triggered):
				_has_triggered.append(child.get_path());
				_waiting_for_callback.append(child.get_path());
				child.trigger();

		if len(_waiting_for_callback) == 0:
			current_trigger += 1;
		
		if current_trigger == 5:
			break;
	
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
		_sprite_fadeaway.destroy(child)

func enemy_dead():
	current_trigger = -2
	current_phase = 'enemy_dead'
	_cull()

func go_to_upgrade_phase():
	current_trigger = -2
	current_phase = 'upgrade'
	_upgrades.activate_upgrade_phase()

func go_to_next_battle():
	current_phase = 'dialog';
	current_level += 1
	_load_enemy(current_level);
	_dialog.start_dialog(current_level)

func start_battle():
	current_trigger = -1
	current_phase = 'battle'

	var player_cockpit = _main_scene.get_children_in_groups(self, ['player_ship_part', 'cockpit'], true)[0]
	player_cockpit.set_shoot_countdown(2 + current_level * 2.0)
	
func _load_enemy(level):
	for child in _enemy.get_children():
		child.queue_free();

	var level_node = _garage.get_node('./lvl_' + str(level))

	for child in level_node.get_children():
		child.reparent(_enemy, false);
	
	_enemy.make_ready();
