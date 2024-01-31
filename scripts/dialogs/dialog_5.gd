extends Node2D

var programme = \
[
	{
		'type': 'player_set_pos_bottom'
	},
	{
		'type': 'enemy_set_pos_battle'
	},
	{
		'type': 'play_music',
		'content': 'platform_theme'
	},
	{
		'type': 'fade_in'
	},
	{
		'type': 'player_warp_into_frame'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'What is this thing?'
	},
	{
		'type': 'reveal_enemy_healthbar',
		'content': 'The Galactic Rangers'
	},
	{
		'type': 'activate_shield'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'color': 'red',
		'content': 'JUST DIE!'
	},
	{
		'type': 'start_battle'
	}
]

