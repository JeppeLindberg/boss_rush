extends Node2D

var _enemy_health: Node2D
var _enemy_name_label: Label



func _ready():
	_enemy_health = get_node('./enemy_health')
	_enemy_name_label = get_node('./enemy_name/label')

func set_enemy_name(new_name):
	_enemy_name_label.text = new_name

func set_max_health(new_max_health):
	_enemy_health.set_max_health(new_max_health)

func set_health(new_health):
	_enemy_health.set_health(new_health)
