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
		'content': 'ranger_theme'
	},
	{
		'type': 'fade_in'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'blue_ranger',
		'color': 'cyan',
		'content': 'This patrol is more uneventful than usual.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'red_ranger',
		'color': 'red',
		'content': 'Boring, you mean?'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'black_ranger',
		'color': 'white',
		'content': 'We have cleaned up the hyperlanes rather effectively.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'black_ranger',
		'color': 'white',
		'content': 'The usual bandits have been dealt with.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'pink_ranger',
		'color': 'pink',
		'content': 'And all the remaining bandits are hiding.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'blue_ranger',
		'color': 'cyan',
		'content': 'Exactly as we planned. It seems our efforts have been fruitful.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'black_ranger',
		'color': 'white',
		'content': 'At this pace, I can retire early.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'pink_ranger',
		'color': 'pink',
		'content': 'Now, you know more than any of us, that if we relent...'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'pink_ranger',
		'color': 'pink',
		'content': '... Evil will return. And even stronger than before.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'red_ranger',
		'color': 'red',
		'content': 'I hope they do. My laser cannon thirsts for synthetic blood.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'blue_ranger',
		'color': 'cyan',
		'content': 'We talked about this. We are the good guys, remember?'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'red_ranger',
		'color': 'red',
		'content': 'You are right of course.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'red_ranger',
		'color': 'red',
		'content': 'But I would not mind a little bit of action.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'pink_ranger',
		'color': 'pink',
		'content': 'Maybe you will get a chance right now. Check the scanner.'
	},
	{
		'type': 'player_warp_into_frame'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'blue_ranger',
		'color': 'cyan',
		'content': 'Halt. State your identity.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'You dont recognize me? Your old nemesis?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'I am hurt! Simply hurt!'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'pink_ranger',
		'color': 'pink',
		'content': '... Doctor Richter? Is that you?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'The one and only!'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'black_ranger',
		'color': 'white',
		'content': 'But how? You died years ago!'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'This old dog has more than a few tricks up his sleeve!'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'red_ranger',
		'color': 'red',
		'content': 'For a doctor, you sure are stupid.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'red_ranger',
		'color': 'red',
		'content': 'We kicked your ass last time, remember?'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'I remember that quite well!'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'black_ranger',
		'color': 'white',
		'content': 'Well, coming back to us was your last mistake.'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'red_ranger',
		'color': 'red',
		'content': 'We will destroy you, and this time you will stay dead.'
	},
	{
		'type': 'player_speech',
		'theme': 'speech',
		'content': 'Bring it on!'
	},
	{
		'type': 'reveal_enemy_healthbar',
		'content': 'The Galactic Rangers'
	},
	{
		'type': 'enemy_speech',
		'theme': 'speech',
		'follow': 'pink_ranger',
		'color': 'pink',
		'content': 'Activating shield now!'
	},
	{
		'type': 'activate_shield'
	},
	{
		'type': 'start_battle'
	}
]

