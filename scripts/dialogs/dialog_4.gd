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
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Oh this is some kind of weapons platform!'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Adding their arsenal to mine will be a treat.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Wazzat? A challenger?'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Are you stupid? This facility is impenetrable.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Go ahead and attack us. Make my day.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Let me ascertain whether your mettle can measure...'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': '... with the assurances proffered by your verbal expressions!'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': '...'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Your long words confuse me.'
	},
	{
		'type': 'reveal_enemy_healthbar',
		'content': 'Gillian Weapons Platform'
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

