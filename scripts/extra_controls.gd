extends Node2D

var skip_dialog: bool

var _upgrade_feedback: Node2D;


func _ready():
	_upgrade_feedback = get_node_or_null('/root/main_scene/upgrade_feedback')

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("toggle_fullscreen"):
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if event.is_action_pressed("skip_dialog"):
			skip_dialog = !skip_dialog;
			if _upgrade_feedback != null:
				if skip_dialog:
					_upgrade_feedback.popup_text('Dialog will be skipped.');
				else:
					_upgrade_feedback.popup_text('Dialog will be shown.');