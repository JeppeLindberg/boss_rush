extends Node2D

var status = 'inactive';
var progress = -1;

@export var animation_len_secs: float = 1.0;
@export var speech_symbols_per_sec: float = 10.0;

@export var speech_color: Color;
@export var speech_player_texture: Texture;
@export var digitized_color: Color;
@export var digitized_player_texture: Texture;
@export var name_reveal_time_to_health_reveal: float = 0.2
@export var time_between_health_reveals: float = 0.15
@export var time_after_health_reveal: float = 0.4

@export var white: Color;
@export var cyan: Color;
@export var red: Color;
@export var pink: Color;

var _main_scene: Node2D
var _center_top: Node2D
var _center_bottom: Node2D
var _player_pos: Node2D
var _enemy_pos: Node2D
var _game_space: Node2D
var _audio: Node2D

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
var _enemy_speech_bubble_enter_promt: Node2D
var _speech_bubble_text_label: RichTextLabel
var _enemy_health_bar: Node2D
var _enemy_name: Node2D
var _enemy_health: Node2D
var _colorize_screen: Node2D

var _from_pos: Vector2
var _target_pos: Vector2
var _animation_node: Node2D
var _waiting_for_finish_animation: bool
var _animation_time_start: float
var _animation_curve: Curve
var _also_animate_alpha: bool
var _inverse_animate_alpha: bool
var _speech_time_start: float
var _waiting_for_finish_speech: bool
var _ready_for_progress_dialog: bool
var _waiting_for_reveal_enemy_health_bar: bool
var _reveal_enemy_health_bar_start: float
var _revealed_name: bool
var _health_reveals_completed = 0
var _waiting_for_post_reveal_enemy_health_bar: bool
var _post_reveal_enemy_health_bar_target_time: float
var _delay_wait_time_finish: float
var _waiting_for_delay: bool

func _ready():
	_main_scene = get_node('/root/main_scene')
	_center_bottom = get_node('/root/main_scene/center_bottom')
	_center_top = get_node('/root/main_scene/center_top')
	_player_pos = get_node('/root/main_scene/player_pos')
	_enemy_pos = get_node('/root/main_scene/enemy_pos')
	_game_space = get_node('/root/main_scene/game_space')
	_player_speech_bubble = get_node('./player_speech_bubble')
	_enemy_health_bar = get_node('/root/main_scene/ui/enemy_health_bar')
	_enemy_name = _enemy_health_bar.get_node('./enemy_name')
	_enemy_health = _enemy_health_bar.get_node('./enemy_health')
	_player_speech_bubble_text_label = _player_speech_bubble.get_node('./label')
	_player_speech_bubble_sprite = _player_speech_bubble.get_node('./sprite')
	_player_speech_bubble_enter_promt = _player_speech_bubble.get_node('./enter_promt')
	_enemy_speech_bubble = get_node('./enemy_speech_bubble')
	_enemy_speech_bubble_text_label = _enemy_speech_bubble.get_node('./bubble/label')
	_enemy_speech_bubble_enter_promt = _enemy_speech_bubble.get_node('./bubble/enter_promt')
	_colorize_screen = get_node('/root/main_scene/colorize_screen')
	_audio = get_node('/root/main_scene/camera/audio')

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

func end_dialog():
	progress = -1;
	status = 'inactive';
	_game_space.start_battle();	

func _process(_delta):
	if status == 'inactive':
		return

	if _waiting_for_finish_animation:
		var animation_progress = min((_main_scene.curr_secs() - _animation_time_start) * (1.0 / animation_len_secs), 1);
		_animation_node.global_position = _from_pos.lerp(_target_pos, _animation_curve.sample(animation_progress));

		if _also_animate_alpha:
			if _inverse_animate_alpha:
				_animation_node.modulate.a = 1.0 - animation_progress;
			else:
				_animation_node.modulate.a = animation_progress;

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
	
	elif _waiting_for_reveal_enemy_health_bar:
		if not _revealed_name:
			_enemy_name.visible = true
			_enemy_name.spawn_animate()
			_revealed_name = true;
	
		var index = 0;
		for child in _enemy_health.get_children():
			if (child.visible == false) and \
			((_main_scene.curr_secs() - _reveal_enemy_health_bar_start) > name_reveal_time_to_health_reveal + time_between_health_reveals * index):
				if child.modulate.a == 0.0:
					_post_reveal_enemy_health_bar_target_time = _main_scene.curr_secs() + time_after_health_reveal
					_waiting_for_reveal_enemy_health_bar = false
					_waiting_for_post_reveal_enemy_health_bar = true
					break;

				child.visible = true
				child.spawn_animate()
				_health_reveals_completed += 1
			
			index += 1

		return;
	
	elif _waiting_for_post_reveal_enemy_health_bar:
		if _main_scene.curr_secs() > _post_reveal_enemy_health_bar_target_time:
			progress_dialog();
	
	elif _waiting_for_delay:
		if _main_scene.curr_secs() > _delay_wait_time_finish:
			progress_dialog();


# Called on any input that has not already been handled by the UI or other sources
func _unhandled_input(event):
	if status == 'inactive':
		return

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
	_waiting_for_post_reveal_enemy_health_bar = false;
	_also_animate_alpha = false;
	_inverse_animate_alpha = false;
	_waiting_for_delay = false;

	if progress == 0:
		_enemy_name.visible = false
		for child in _enemy_health.get_children():
			child.visible = false

	print(current_programme['type'])

	if true:
		# skip dialog
		if current_programme['type'] == 'player_speech' or current_programme['type'] == 'enemy_speech':
			progress_dialog()
			return

	if current_programme['type'] == 'player_set_pos_bottom':		
		_player.global_position = _center_bottom.global_position + Vector2.DOWN * 15.0
		progress_dialog()
		return;

	if current_programme['type'] == 'enemy_set_pos_battle':		
		_enemy.global_position = _enemy_pos.global_position
		progress_dialog()
		return;

	if current_programme['type'] == 'enemy_set_pos_top':		
		_enemy.global_position = _center_top.global_position + Vector2.UP * 15.0
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

	if current_programme['type'] == 'player_warp_into_frame':		
		_from_pos = _player.global_position
		_target_pos = _player_pos.global_position
		_animation_node = _player
		_waiting_for_finish_animation = true
		_animation_time_start = _main_scene.curr_secs()
		_animation_curve = _main_scene.logathrithmic_curve
		_also_animate_alpha = true;
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

		if current_programme.get('follow', false):
			var follow_target = _main_scene.get_children_in_groups(_game_space, [current_programme['follow']], true)[0];
			_enemy_speech_bubble.talking_node = follow_target
		else:
			var enemy_cockpit = _main_scene.get_children_in_groups(_game_space, ['enemy_ship_part', 'cockpit'], true)[0];
			_enemy_speech_bubble.talking_node = enemy_cockpit

		if current_programme.get('theme', false):
			_enemy_speech_bubble.set_theme(current_programme['theme'])
		else:
			_enemy_speech_bubble.set_theme('speech')
		
		if current_programme.get('color', false):
			if current_programme['color'] == 'white':
				_enemy_speech_bubble.set_color(white);
			if current_programme['color'] == 'red':
				_enemy_speech_bubble.set_color(red);
			if current_programme['color'] == 'cyan':
				_enemy_speech_bubble.set_color(cyan);
			if current_programme['color'] == 'pink':
				_enemy_speech_bubble.set_color(pink);
		else:
			_enemy_speech_bubble.set_color(white);
				
		return;

	if current_programme['type'] == 'reveal_enemy_healthbar':
		_waiting_for_reveal_enemy_health_bar = true
		_revealed_name = false;
		_enemy_health_bar.visible = true;
		_enemy_health_bar.set_enemy_name(current_programme['content'])
		_reveal_enemy_health_bar_start = _main_scene.curr_secs()
		_health_reveals_completed = 0
		return;

	if current_programme['type'] == 'activate_shield':
		_enemy.activate_shield();
		_delay_wait_time_finish = _main_scene.curr_secs() + 0.5;
		_waiting_for_delay = true;
		return;

	if current_programme['type'] == 'fade_in':		
		_from_pos = _colorize_screen.global_position
		_target_pos = _colorize_screen.global_position
		_animation_node = _colorize_screen
		_waiting_for_finish_animation = true
		_animation_time_start = _main_scene.curr_secs()
		_animation_curve = _main_scene.linear_curve
		_also_animate_alpha = true;
		_inverse_animate_alpha = true
		_process(0)
		return;

	if current_programme['type'] == 'play_music':
		if current_programme['content'] == 'nova_theme':
			_audio.play_nova_theme()
		if current_programme['content'] == 'alexander_theme':
			_audio.play_alexander_theme()
		if current_programme['content'] == 'drone_theme':
			_audio.play_drone_theme()
		if current_programme['content'] == 'platform_theme':
			_audio.play_platform_theme()
		if current_programme['content'] == 'ranger_theme':
			_audio.play_ranger_theme()
		
		progress_dialog()
		return;

	if current_programme['type'] == 'start_battle':
		end_dialog()
		return;






