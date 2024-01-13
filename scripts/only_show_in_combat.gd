extends Node2D

var _game_space: Node2D


func _ready():
	_game_space = get_node('/root/main_scene/game_space')


func _process(_delta):
	self.visible = _game_space.current_phase == 'battle';
