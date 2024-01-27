extends Node2D

var programme = \
[
	{
		'type': 'player_set_pos_bottom'
	},
	{
		'type': 'enemy_set_pos_top'
	},
	{
		'type': 'play_music',
		'content': 'drone_theme'
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
		'content': 'Phew. That cadet was more trouble than I expected.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Wait, something is approaching...'
	},
	{
		'type': 'enemy_move_into_frame'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Uhh... hello?'
	},
	{
		'type': 'enemy_speech',
		'theme': 'digitized',
		'color': 'red',
		'content': 'YOUR ACTIONS HAVE VIOLATED THE LAW'
	},
	{
		'type': 'enemy_speech',
		'theme': 'digitized',
		'color': 'red',
		'content': 'THE GALACTIC FEDERATION HAS AUTHORISED YOUR DESTRUCTION'
	},
	{
		'type': 'enemy_speech',
		'theme': 'digitized',
		'color': 'red',
		'content': 'DO YOU HAVE ANYHING TO SAY IN YOUR DEFENCE?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'You will never take me alive!'
	},
	{
		'type': 'activate_shield'
	},
	{
		'type': 'reveal_enemy_healthbar',
		'content': 'X-300 Justice Drone'
	},
	{
		'type': 'enemy_speech',
		'theme': 'digitized',
		'color': 'red',
		'content': 'SO BE IT'
	},
	{
		'type': 'start_battle'
	}
]

