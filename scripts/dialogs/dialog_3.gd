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
		'type': 'fade_in'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Wow, I got accepted!'
	},
	{
		'type': 'player_warp_into_frame'
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
		'theme': 'speech',
		'content': 'You will regret this!'
	},
	{
		'type': 'start_battle'
	}
]

