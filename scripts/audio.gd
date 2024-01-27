extends AudioListener2D

@export var alexander_theme_path: String
@export var drone_theme_path: String
@export var platform_theme_path: String

var _main_scene: Node2D


func _ready():
	_main_scene = get_node('/root/main_scene')

func play_alexander_theme():
	play_theme(alexander_theme_path)

func play_drone_theme():
	play_theme(drone_theme_path)

func play_platform_theme():
	play_theme(platform_theme_path)

func play_theme(path):
	var current_music = _main_scene.get_children_in_groups(self, ['music'], false)

	for node in current_music:
		node.queue_free()
	
	var new_music = _main_scene.create_node(path, self);
	new_music.position = Vector2.ZERO;

