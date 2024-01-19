extends Node2D

var _enemy_health: Node2D
var _enemy_name_label: Label



func _ready():
	_enemy_health = get_node('./enemy_health')
	_enemy_name_label = get_node('./enemy_name/label')

func set_enemy_name(new_name):
	_enemy_name_label.text = new_name

func set_max_health(new_max_health, new_max_shield):
	_enemy_health.set_max_health(new_max_health, new_max_shield)

func set_health(new_health, new_shield):
	_enemy_health.set_health(new_health, new_shield)

func hide_health_bar():
	visible = false;

	for child in _enemy_health.get_children():
		child.modulate.a = 0;
