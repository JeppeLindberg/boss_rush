extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('/root/main_menu/camera/audio').play_menu_theme()
