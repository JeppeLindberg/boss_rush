extends Node2D

var _prev_phase

var _sprite: Sprite2D
var _game_space: Node2D


func _ready():
	_game_space = get_node('/root/main_scene/game_space')
	_sprite = get_node('./sprite')

func _process(_delta):
	self.visible = _prev_phase == 'upgrade' and _game_space.current_level == 1;

	if _game_space.current_phase == 'upgrade' and _prev_phase != 'upgrade':
		_sprite.start_animation()

	_prev_phase = _game_space.current_phase


			

