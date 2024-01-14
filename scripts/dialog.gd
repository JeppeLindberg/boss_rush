extends Node2D

var status = 'inactive';
var progress = -1;

@export var animation_len_secs: float = 1.0;
@export var speech_symbols_per_sec: float = 10.0;

@export var speech_color: Color;
@export var speech_player_texture: Texture;
@export var digitized_color: Color;
@export var digitized_player_texture: Texture;

var _main_scene: Node2D
var _center_top: Node2D
var _center_bottom: Node2D
var _player_pos: Node2D
var _enemy_pos: Node2D

var _dialog_node: Node2D
var _enemy_cockpit: Node2D
var _enemy: Node2D
var _player_cockpit: Node2D
var _player: Node2D
var _player_speech_bubble: Node2D
var _player_speech_bubble_text_label: RichTextLabel
var _player_speech_bubble_sprite: Node2D
var _player_speech_bubble_enter_promt: Node2D
var _enemy_speech_bubble: Node2D
var _enemy_speech_bubble_text_label: RichTextLabel
var _enemy_speech_bubble_sprite: Node2D
var _enemy_speech_bubble_enter_promt: Node2D
var _speech_bubble_text_label: RichTextLabel

var _from_pos: Vector2
var _target_pos: Vector2
var _animation_node: Node2D
var _waiting_for_finish_animation: bool
var _animation_time_start: float
var _animation_curve: Curve
var _speech_time_start: float
var _waiting_for_finish_speech: bool
var _ready_for_progress_dialog: bool

func _ready():
	_main_scene = get_node('/root/main_scene')
	_center_bottom = get_node('/root/main_scene/center_bottom')
	_center_top = get_node('/root/main_scene/center_top')
	_player_pos = get_node('/root/main_scene/player_pos')
	_enemy_pos = get_node('/root/main_scene/enemy_pos')
	_player_speech_bubble = get_node('./player_speech_bubble')
	_player_speech_bubble_text_label = _player_speech_bubble.get_node('./label')
	_player_speech_bubble_sprite = _player_speech_bubble.get_node('./sprite')
	_player_speech_bubble_enter_promt = _player_speech_bubble.get_node('./enter_promt')
	_enemy_speech_bubble = get_node('./enemy_speech_bubble')
	_enemy_speech_bubble_text_label = _enemy_speech_bubble.get_node('./label')
	_enemy_speech_bubble_sprite = _enemy_speech_bubble.get_node('./sprite')
	_enemy_speech_bubble_enter_promt = _enemy_speech_bubble.get_node('./enter_promt')

func start_dialog(dialog_index):
	progress = -1;
	status = 'active';
	_dialog_node = get_node('./dialog_' + str(dialog_index));

	_enemy = get_node('/root/main_scene/game_space/enemy');
	_enemy_cockpit = _main_scene.get_children_in_groups(_enemy, ['enemy_ship_part', 'cockpit'], true)[0];
	_player = get_node('/root/main_scene/game_space/player');
	_player_cockpit = _main_scene.get_children_in_groups(_player, ['player_ship_part', 'cockpit'], true)[0];

	_enemy.global_position = _center_top.global_position + Vector2.UP * 15.0

	progress_dialog()

func _process(_delta):
	if _waiting_for_finish_animation:
		var animation_progress = min((_main_scene.curr_secs() - _animation_time_start) * (1.0 / animation_len_secs), 1);
		_animation_node.global_position = _from_pos.lerp(_target_pos, _animation_curve.sample(animation_progress));

		if (animation_progress == 1) and _waiting_for_finish_animation:
			_waiting_for_finish_animation = false;
			progress_dialog()

	elif _waiting_for_finish_speech:
		var symbols_visible = int((_main_scene.curr_secs() - _speech_time_start) * speech_symbols_per_sec)
		_speech_bubble_text_label.visible_characters = symbols_visible

		if _speech_bubble_text_label.visible_ratio >= 1.0:
			_waiting_for_finish_speech = false;
			_player_speech_bubble_enter_promt.start_animation()
			_enemy_speech_bubble_enter_promt.start_animation()
			_player_speech_bubble_enter_promt.visible = true;
			_enemy_speech_bubble_enter_promt.visible = true;
			_ready_for_progress_dialog = true;

# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	if event.is_action_pressed("continue_dialog"):
		if _waiting_for_finish_speech:
			_speech_time_start = 0.0;
		elif _ready_for_progress_dialog:
			progress_dialog()

func progress_dialog():
	progress += 1;
	var current_programme = _dialog_node.programme[progress]
	_player_speech_bubble.visible = false;
	_enemy_speech_bubble.visible = false;
	_ready_for_progress_dialog = false;
	_waiting_for_finish_speech = false;
	_waiting_for_finish_animation = false;
	_player_speech_bubble_enter_promt.visible = false;
	_enemy_speech_bubble_enter_promt.visible = false;

	if current_programme['type'] == 'player_set_pos_bottom':		
		_player.global_position = _center_bottom.global_position + Vector2.DOWN * 15.0
		progress_dialog()
		return;

	if current_programme['type'] == 'player_move_into_frame':		
		_from_pos = _player.global_position
		_target_pos = _player_pos.global_position
		_animation_node = _player
		_waiting_for_finish_animation = true
		_animation_time_start = _main_scene.curr_secs()
		_animation_curve = _main_scene.linear_curve
		return;

	if current_programme['type'] == 'enemy_move_into_frame':		
		_from_pos = _enemy.global_position
		_target_pos = _enemy_pos.global_position
		_animation_node = _enemy
		_waiting_for_finish_animation = true
		_animation_time_start = _main_scene.curr_secs()
		_animation_curve = _main_scene.linear_curve
		return;
	
	if current_programme['type'] == 'player_speech':
		_player_speech_bubble.visible = true;
		
		if current_programme['theme'] == 'speech':
			_player_speech_bubble_text_label.modulate = speech_color
			_player_speech_bubble_sprite.texture = speech_player_texture

		if current_programme['theme'] == 'digitized':
			_player_speech_bubble_text_label.modulate = digitized_color
			_player_speech_bubble_sprite.texture = digitized_player_texture

		_speech_bubble_text_label = _player_speech_bubble_text_label
		_speech_bubble_text_label.text = '[center]'+current_programme['content']
		_speech_bubble_text_label.visible_characters = 0
		_speech_time_start = _main_scene.curr_secs()
		_waiting_for_finish_speech = true
		return;
	
	if current_programme['type'] == 'enemy_speech':
		_enemy_speech_bubble.visible = true;

		_speech_bubble_text_label = _enemy_speech_bubble_text_label
		_speech_bubble_text_label.text = '[center]'+current_programme['content']
		_speech_bubble_text_label.visible_characters = 0
		_speech_time_start = _main_scene.curr_secs()
		_waiting_for_finish_speech = true
		return;






