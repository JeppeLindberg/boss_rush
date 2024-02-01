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

var _main_scene: Node2D

var _music_queue: Array = []


func _ready():
	_main_scene = get_node_or_null('/root/main_scene')
	if _main_scene == null or _main_scene.is_queued_for_deletion():
		_main_scene = get_node('/root/main_menu')

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

func _play_music():
	var current_music = _main_scene.get_children_in_groups(self, ['music'], false)
	for node in current_music:
		node.queue_free()
	
	var new_music:AudioStreamPlayer2D = _main_scene.create_node(_music_queue[0], self);
	new_music.position = Vector2.ZERO;
	new_music.connect("finished", _play_music)

	if len(_music_queue) != 1:
		_music_queue.pop_front()


