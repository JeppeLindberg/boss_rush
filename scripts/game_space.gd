extends Node2D

var _main_scene: Node2D
var _enemy: Node2D
var _upgrades: Node2D
var _garage: Node2D
var _dialog: Node2D
var _sprite_fadeaway: Node2D
var _warnings: Node2D
var _colorize_screen: Node2D
var _ui: Node2D

var current_level = 4;
var current_trigger = -1;
var current_phase = '';
var _has_triggered = []
var _waiting_for_callback = []
var _fade_callback = []

@export var game_over_path: String
@export var victory_path: String


func _ready():
	_main_scene = get_node('/root/main_scene');
	_garage = get_node('/root/main_scene/garage');
	_dialog = get_node('/root/main_scene/dialog');
	_sprite_fadeaway = get_node('/root/main_scene/sprite_fadeaway');
	_warnings = get_node('/root/main_scene/ui/warnings')
	_ui = get_node('/root/main_scene/ui')
	_upgrades = get_node('./upgrades');
	_enemy = get_node('./enemy');
	_colorize_screen = get_node('/root/main_scene/colorize_screen')

func _process(_delta):
	if (current_trigger == -1) or (current_phase != 'battle'):
		return;
	
	while len(_waiting_for_callback) == 0:
		for child in _main_scene.get_children_in_groups(self, ['has_auto_trigger'], true):
			if (child.auto_trigger_order == current_trigger) and not (child.get_path() in _has_triggered):
				_has_triggered.append(child.get_path());
				_waiting_for_callback.append(child.get_path());
				_warnings.clear_warnings(child);
				child.trigger();

		if len(_waiting_for_callback) == 0:
			current_trigger += 1;
		
		if current_trigger == 5:
			break;
	
	if current_trigger == 5:
		current_trigger = -1;

func finish_lerp_to_pos(node):
	_fade_callback.erase(node.get_path());

	if len(_fade_callback) == 0:
		if current_phase == 'victory':
			_reveal_victory_menu();
		elif current_phase == 'game_over':
			_reveal_game_over_menu();

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
	_warnings.clear_all_warnings()
	_cull()

func player_dead():
	current_trigger = -2
	current_phase = 'player_dead'
	_warnings.clear_all_warnings()
	_cull()

func go_to_upgrade_phase():
	if current_level == 5:
		go_to_victory()
		return;
	
	current_trigger = -2
	current_phase = 'upgrade'
	_upgrades.activate_upgrade_phase()

func go_to_victory():
	current_trigger = -2
	current_phase = 'victory'

	_colorize_screen.animation_len_secs = 1.0;
	_colorize_screen.alpha_modifier = 0.5;
	_fade_callback.append(_colorize_screen.get_path());
	_colorize_screen.set_lerp_to_pos(_colorize_screen.global_position, _main_scene.rising_curve, self, _colorize_screen, 'fade_in')

func go_to_game_over():
	current_trigger = -2
	current_phase = 'game_over'

	_colorize_screen.animation_len_secs = 1.0;
	_colorize_screen.alpha_modifier = 0.5;
	_fade_callback.append(_colorize_screen.get_path());
	_colorize_screen.set_lerp_to_pos(_colorize_screen.global_position, _main_scene.rising_curve, self, _colorize_screen, 'fade_in')

func _reveal_game_over_menu():
	_main_scene.create_node(game_over_path, _main_scene)

func _reveal_victory_menu():
	_main_scene.create_node(victory_path, _main_scene)

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
