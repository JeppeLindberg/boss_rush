extends Node2D

@export var fade_in_secs: float = 0.25
@export var duration_secs: float = 4.0
@export var fade_out_secs: float = 0.25
@export var visibility_curve: Curve;

var _main_scene: Node2D
var _text: Label

var _popup_start: float = -1.0


func _ready():
	_main_scene = get_node('/root/main_scene')
	_text = get_node('./text')

func _process(_delta):
	if _popup_start == -1.0:
		return
	
	var elapsed_time = _main_scene.curr_secs() - _popup_start

	if elapsed_time < fade_in_secs:
		var weight = visibility_curve.sample(min(1.0, elapsed_time * (1.0 / fade_in_secs)))
		self.modulate.a = lerp(0, 1, weight)
		return

	if fade_in_secs < elapsed_time and elapsed_time < (fade_in_secs + duration_secs):
		self.modulate.a = 1.0
		return

	if (fade_in_secs + duration_secs) < elapsed_time:
		var weight = visibility_curve.sample( 1.0 - min(1.0, (elapsed_time - fade_in_secs - duration_secs) * (1.0 / fade_out_secs)))
		self.modulate.a = lerp(0, 1, weight)
		
		if weight == 1.0:
			_popup_start = -1.0;

func popup_text(text):
	visible = true
	self.modulate.a = 0.0
	_popup_start = _main_scene.curr_secs()
	_text.text = text;

