extends Node2D

var _ui_enemy_health: Node2D
var _main_scene: Node2D
var _game_space: Node2D

var health: int




func make_ready():
    _ui_enemy_health = get_node('/root/main_scene/ui/enemy_health');
    _main_scene = get_node('/root/main_scene');
    _game_space = get_node('/root/main_scene/game_space');
    var ship_parts = _main_scene.get_children_in_groups(self, ['enemy_ship_part'], false);
    health = len(ship_parts) - 2;
    _ui_enemy_health.set_max_health(health);


func take_damage():
    health -= 1
    _ui_enemy_health.set_health(health);

    if health == 0:
        _game_space.go_to_upgrade_phase();
