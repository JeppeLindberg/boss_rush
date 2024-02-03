extends AudioListener2D

@export var menu_intro_path: String
@export var menu_theme_path: String
@export var nova_intro_path: String
@export var nova_theme_path: String
@export var alexander_intro_path: String
@export var alexander_theme_path: String
@export var drone_intro_path: String
@export var drone_theme_path: String
@export var platform_intro_path: String
@export var platform_theme_path: String
@export var ranger_intro_path: String
@export var ranger_theme_path: String

@export var button_select: String
@export var cant_do_that: String
@export var character_death: String
@export var explosion_1: String
@export var explosion_2: String
@export var low_health: String
@export var mine_deploy: String
@export var player_warp: String
@export var retro_speech: String
@export var shield_power_down: String
@export var shield_power_up: String
@export var upgrade_select: String
@export var victory: String

var _main_scene: Node2D
var _center: Node2D

var _max_sfx_amount: int = 20
var _music_queue: Array = []
var _music_vol_multiplier: float = 0.2
var _overlap_group: Array = []


func _ready():
	make_ready()
	
	_play_sfx(retro_speech)
	set_playing_retro_speech_sfx(false);

func make_ready():
	_main_scene = get_node_or_null('/root/main_scene')
	if _main_scene == null or _main_scene.is_queued_for_deletion():
		_main_scene = get_node('/root/main_menu')
	_center = get_node_or_null('/root/main_scene/center')
	if _center == null or _center.is_queued_for_deletion():
		_center = get_node('/root/main_menu/center')

func _process(_delta):
	_overlap_group.clear();

func play_button_select_sfx():
	_play_sfx(button_select)
func play_cant_do_that_sfx():
	_play_sfx(cant_do_that)
func play_character_death_sfx():
	_play_sfx(character_death)
func play_explosion_sfx():
	_play_sfx([explosion_1, explosion_2].pick_random(), 'explosion');
func play_low_health_sfx():
	_play_sfx(low_health);
func play_mine_deploy_sfx():
	_play_sfx(mine_deploy, 'mine_deploy');
func play_player_warp_sfx():
	_play_sfx(player_warp);
func set_playing_retro_speech_sfx(new_playing):
	_set_playing('speech', new_playing);
func play_shield_power_down_sfx():
	_play_sfx(shield_power_down);
func play_shield_power_up_sfx():
	_play_sfx(shield_power_up);
func play_upgrade_select_sfx():
	_play_sfx(upgrade_select);
func play_victory_sfx():
	var current_music = _main_scene.get_children_in_groups(self, ['music'], false)
	for node in current_music:
		node.queue_free()
	_play_sfx(victory);

func play_menu_theme():
	_music_queue.clear()
	_music_queue.append(menu_intro_path)
	_music_queue.append(menu_theme_path)
	_play_music()

func play_nova_theme():
	_music_queue.clear()
	_music_queue.append(nova_intro_path)
	_music_queue.append(nova_theme_path)
	_play_music()

func play_alexander_theme():
	_music_queue.clear()
	_music_queue.append(alexander_intro_path)
	_music_queue.append(alexander_theme_path)
	_play_music()

func play_drone_theme():
	_music_queue.clear()
	_music_queue.append(drone_intro_path)
	_music_queue.append(drone_theme_path)
	_play_music()

func play_platform_theme():
	_music_queue.clear()
	_music_queue.append(platform_intro_path)
	_music_queue.append(platform_theme_path)
	_play_music()

func play_ranger_theme():
	_music_queue.clear()
	_music_queue.append(ranger_intro_path)
	_music_queue.append(ranger_theme_path)
	_play_music()

func _play_sfx(path, overlap_group = ''):	
	make_ready()
	if overlap_group != '':
		if overlap_group in _overlap_group:
			return
		_overlap_group.append(overlap_group)

	var new_sfx:AudioStreamPlayer2D = _main_scene.create_node(path, self);
	new_sfx.global_position = _center.global_position;

	var current_sfx = _main_scene.get_children_in_groups(self, ['sfx'], false)
	var nodes_to_free = len(current_sfx) - _max_sfx_amount;
	var index = 0;
	for node in current_sfx:
		if index < nodes_to_free:
			node.queue_free()
		index += 1

func _set_playing(group, new_playing):
	make_ready()
	var current_sfx = _main_scene.get_children_in_groups(self, [group], false)
	for node in current_sfx:
		node.playing = new_playing;

func _play_music():
	make_ready()
	var current_music = _main_scene.get_children_in_groups(self, ['music'], false)
	for node in current_music:
		node.queue_free()
	
	var new_music:AudioStreamPlayer2D = _main_scene.create_node(_music_queue[0], self);
	new_music.volume_db = -10 * (1-_music_vol_multiplier)
	new_music.global_position = _center.global_position;
	new_music.connect("finished", _play_music)

	if len(_music_queue) != 1:
		_music_queue.pop_front()


