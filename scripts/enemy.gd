extends Node2D

var _ui_enemy_health_bar: Node2D
var _main_scene: Node2D
var _game_space: Node2D

var health: int


func make_ready():
	_ui_enemy_health_bar = get_node('/root/main_scene/ui/enemy_health_bar');
	_main_scene = get_node('/root/main_scene');
	_game_space = get_node('/root/main_scene/game_space');
	health = len(get_children()) - 2;
	_ui_enemy_health_bar.set_max_health(health);

	for child in get_children():
		child.make_ready();


func take_damage():
	health -= 1
	_ui_enemy_health_bar.set_health(health);

	if health == 0:
		_game_space.go_to_upgrade_phase();
