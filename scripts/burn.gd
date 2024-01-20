extends Node2D

var _game_space: Node2D
var _special_effects: Node2D

var _burn_countdown: Node2D
var _burn_countdown_label: Label

var auto_trigger_order = 4;
var swappable: bool
var swappable_reason = 'Always';



func _ready():
	add_to_group('burn');
	add_to_group('has_auto_trigger');
	_game_space = get_node('/root/main_scene/game_space')
	_special_effects = get_node('/root/main_scene/special_effects')
	_burn_countdown = get_node('./burn_countdown');
	_burn_countdown_label = get_node('./burn_countdown/label');

	if get_parent().is_in_group('cockpit'):
		_burn_countdown_label.text = str(int(int(_burn_countdown_label.text) * 1.5))

func trigger():
	var countdown_integer = int(_burn_countdown_label.text);
	countdown_integer -= 1;

	if countdown_integer == 0:
		_burn();
	
	_burn_countdown_label.text = str(countdown_integer);

	_game_space.finish_trigger(self);

func _burn():
	_special_effects.explosion(global_position);
	get_parent().take_damage();