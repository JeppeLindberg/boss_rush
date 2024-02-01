extends Node2D

var programme = \
[
	{
		'type': 'player_set_pos_bottom'
	},
	{
		'type': 'play_music',
		'content': 'nova_theme'
	},
	{
		'type': 'fade_in'
	},
	{
		'type': 'player_move_into_frame'
	},
	{
		'type': 'player_speech',
		'theme': 'digitized',
		'content': 'KZZT!'
	},
	{
		'type': 'player_speech',
		'theme': 'digitized',
		'content': 'Neurons normalized.'
	},
	{
		'type': 'player_speech',
		'theme': 'digitized',
		'content': 'BZZZZZT!'
	},
	{
		'type': 'player_speech',
		'theme': 'digitized',
		'content': 'Activating brain...'
	},
	{
		'type': 'player_speech',
		'theme': 'digitized',
		'content': 'BRRRRRR- beep'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'AAAAAAAAAAAAAAAAAAA-, wait.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'IT WORKED?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Ahem. I mean, of course it worked.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'After all, my calculations are always correct.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Now I can finally enact revenge on those pesky rangers!'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'They really thought that destroying my body would stop me?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'This ship is more powerful than my old body ever were.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'I FEEL INVINCIBLE!'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'However, I did maybe skimp a little bit too much on the hardware...'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Ah, no matter. I need to test out this new body.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'I see a nearby space station. That will do.'
	},
	{
		'type': 'enemy_move_into_frame'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'GIVE ME ALL YOUR STUFF!'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Pardon?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'I WILL DESTROY YOUR FEEBLE STATION!'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Is that... a brain in a jar? Piloting a ship?'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Is this some kind of joke?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Laugh all you want. I will be the one laughing in the end.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'content': 'Know that we will NOT be giving you all our stuff.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'I will just take it by force then.'
	},
	{
		'type': 'reveal_enemy_healthbar',
		'content': 'Jar full of Brains'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'If you start to cry, make sure to turn on the intercom. I want to hear it.'
	},
	{
		'type': 'start_battle'
	}
]

