extends Node2D


func set_current_level(current_level):
	for child in get_children():
		child.visible = child.name == 'lvl_' + str(current_level)
