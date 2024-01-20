extends Node2D

var _main_scene: Node2D
var _game_space: Node2D
var _special_effects: Node2D

var auto_trigger_order = 1;

var _trigger_end_time: float
@export var animation_len_secs: float = 1.0;
var _waiting_for_finish_trigger: bool


func _ready():
	add_to_group('has_auto_trigger');
	add_to_group('cullable');
	_main_scene = get_node('/root/main_scene');
	_game_space = get_node('/root/main_scene/game_space');
	_special_effects = get_node('/root/main_scene/special_effects');

func trigger():
	_trigger_end_time = _main_scene.curr_secs() + animation_len_secs;
	_waiting_for_finish_trigger = true;

	var player_ship_parts = _main_scene.get_children_in_groups(_game_space, ['damageable_player_ship_part'], true);

	for player_ship_part in player_ship_parts:
		if player_ship_part.global_position.x == global_position.x:
			_special_effects.explosion(player_ship_part.global_position);
			player_ship_part.take_damage();
			break;
	
func _process(_delta):
	if not _waiting_for_finish_trigger:
		return;

	if _main_scene.curr_secs() >= _trigger_end_time:
		_waiting_for_finish_trigger = false;
		self.queue_free();
		_game_space.finish_trigger(self);

