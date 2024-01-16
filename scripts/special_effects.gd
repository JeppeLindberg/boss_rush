extends Node2D


@export var explosion_path: String

var _main_scene: Node2D

func _ready():
	_main_scene = get_node("/root/main_scene")

func explosion(pos):
	var new_node = _main_scene.create_node(explosion_path, self)
	new_node.global_position = pos