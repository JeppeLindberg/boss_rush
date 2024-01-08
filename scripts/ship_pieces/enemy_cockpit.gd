extends Node2D


func _ready():
	add_to_group('enemy_ship_part');

func take_damage():
	print('take_damage_enemy');
