extends Node2D


@export var explosion_path: String
@export var multi_explosion_delay: float = 0.2
@export var screen_shake_curve: Curve
@export var screen_shake_y_mult: float = 0.9
@export var screen_shake_amount: Curve
@export var screen_shake_speed: float = 4.0
@export var screen_shake_duration: float = 0.5
@export var screen_shake_distance: float = 5.0

var _main_scene: Node2D
var _camera: Node2D

var _multi_explosion_locations: Array = []
var _last_multi_explosion_time: float = 0
var _screen_shakes: Array = []
var _screen_shake_start_pos = Vector2(0, 0)

func _ready():
	_main_scene = get_node("/root/main_scene")
	_camera = get_node("/root/main_scene/camera")
	_screen_shake_start_pos = _camera.global_position

func _process(_delta):
	if (len(_multi_explosion_locations) > 0) and (_main_scene.curr_secs() > _last_multi_explosion_time + multi_explosion_delay):
		_last_multi_explosion_time = _main_scene.curr_secs()

		var rand_index = randi() % len(_multi_explosion_locations)
		var rand_pos = _multi_explosion_locations[rand_index][0]
		var altered_pos = rand_pos + Vector2(randf_range(-20, 20), randf_range(-20, 20))

		explosion(altered_pos)
		_multi_explosion_locations[rand_index][1] -= 1
		if _multi_explosion_locations[rand_index][1] <= 0:
			_multi_explosion_locations.remove_at(rand_index)
	
	if len(_screen_shakes) > 0:
		var highest_shake_amount: float = 0
		var highest_shake_amount_progress: float = 0

		for i in range(len(_screen_shakes) -1, -1, -1):
			var shake = _screen_shakes[i]
			var time = shake[0]
			var intensity = shake[1]
			var elapsed = _main_scene.curr_secs() - time
			var progress = elapsed / screen_shake_duration
			if progress > 1:
				_screen_shakes.remove_at(i);
				continue;

			var amount = screen_shake_amount.sample(progress) * intensity
			if amount > highest_shake_amount:
				highest_shake_amount = amount;
				highest_shake_amount_progress = progress;

		if highest_shake_amount > 0:
			var amount = highest_shake_amount * screen_shake_distance

			var offset_x = fmod(highest_shake_amount_progress + (_main_scene.curr_secs() * screen_shake_speed), 1.0)
			var offset_y = fmod(highest_shake_amount_progress + (_main_scene.curr_secs() * screen_shake_y_mult * screen_shake_speed), 1.0)

			var x = screen_shake_curve.sample(offset_x) * amount
			var y = screen_shake_curve.sample(offset_y) * amount

			_camera.global_position = _screen_shake_start_pos + Vector2(x, y)
	else:
		_camera.global_position = _screen_shake_start_pos

func explosion(pos):
	var new_node = _main_scene.create_node(explosion_path, self)
	new_node.global_position = pos
	screen_shake([0.4, 0.6].pick_random());

func multi_explosion(pos):
	_multi_explosion_locations.append([pos, 2]);
	_last_multi_explosion_time = _main_scene.curr_secs();

func screen_shake(intensity = 1.0):
	_screen_shakes.append([_main_scene.curr_secs(), intensity])
