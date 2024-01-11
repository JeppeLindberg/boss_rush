extends Area2D

var animation_len_secs: float = 1.0;
var _clicked_this = false;

var player_upgrade_part_path: String

@export var drag_arrow_path: String

var _main_scene: Node2D
var _upgrades: Node2D
var _collider: Node2D


func _ready():
	_main_scene = get_node('/root/main_scene')
	_upgrades = get_node('/root/main_scene/game_space/upgrades')
	_collider = get_node('./collider')
	_collider.disabled = true;
	self.visible = false

func _unhandled_input(event):
	if not self.visible:
		return;

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
			_clicked_this = _main_scene.is_pos_overlapping_collider(_collider, event.position)

		elif (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			if _clicked_this and _main_scene.is_pos_overlapping_collider(_collider, event.position):
				_upgrades.continue_button_pressed()
		
func enable():
	self.visible = true
	_collider.disabled = false;
	
func disable():
	self.visible = false
	_collider.disabled = true;

			

