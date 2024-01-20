extends Node2D

@export var shield_size_5_path: String

var _ui_enemy_health_bar: Node2D
var _main_scene: Node2D
var _game_space: Node2D
var _special_effects: Node2D

var health: int
var shield: int
var _go_to_upgrade_phase_time: float = -1


func make_ready():
	_ui_enemy_health_bar = get_node('/root/main_scene/ui/enemy_health_bar');
	_main_scene = get_node('/root/main_scene');
	_game_space = get_node('/root/main_scene/game_space');
	_special_effects = get_node('/root/main_scene/special_effects');

	shield = 0;

	for child in get_children():
		child.make_ready();
		if child.is_in_group('cockpit'):
			shield += child.shield;
		
	health = len(_main_scene.get_children_in_groups(self, ['enemy_ship_part'], true)) - 2;
	_ui_enemy_health_bar.set_max_health(health, shield);

func _process(_delta):
	if _go_to_upgrade_phase_time != -1 and _main_scene.curr_secs() > _go_to_upgrade_phase_time:
		_go_to_upgrade_phase_time = -1;
		_game_space.go_to_upgrade_phase();

func has_shield():
	return shield > 0;

func activate_shield():
	if shield > 0:
		for child in get_children():
			if child.is_in_group('cockpit'):
				var shield_node = _main_scene.create_node(shield_size_5_path, child);
				shield_node.position = Vector2.ZERO;

func deactivate_shield():
	if shield == 0:
		for child in get_children():
			if child.is_in_group('cockpit'):
				for cchild in child.get_children():
					if cchild.name == 'shield':
						cchild.queue_free();

func take_damage():
	print('enemy take damage');
	if shield > 0:
		shield -= 1

		if shield == 0:
			deactivate_shield();
	else:
		health -= 1

	_ui_enemy_health_bar.set_health(health, shield);

	if health == 0:
		var _enemy_ship_parts = _main_scene.get_children_in_groups(self, ['enemy_ship_part'], true);

		for ship_part in _enemy_ship_parts:
			_special_effects.multi_explosion(ship_part.global_position);

		_special_effects.screen_shake();

		_go_to_upgrade_phase_time = _main_scene.curr_secs() + _special_effects.multi_explosion_delay * len(_enemy_ship_parts) * 2;

		_game_space.enemy_dead();
