extends Node2D

var talking_node: Node2D

@export var speech_bubble: Texture;
@export var speech_bubble_behind: Texture;
@export var speech_digitized: Texture;
@export var speech_digitized_behind: Texture;
@export var arrow_bubble: Texture;
@export var arrow_digitized: Texture;

var _bubble: Node2D
var _bubble_sprite: Sprite2D
var _bubble_behind: Sprite2D
var _arrow: Node2D
var _arrow_sprite: Sprite2D
var _arrow_behind: Sprite2D
var _center: Node2D
var _label: RichTextLabel

var _bubble_initial_pos: Vector2
var _bubble_distance_to_center_x: float


func _ready():
	_bubble = get_node('./bubble');
	_bubble_sprite = get_node('./bubble/bubble')
	_bubble_behind = get_node('./bubble/bubble/bubble_behind')
	_arrow_sprite = get_node('./arrow/arrow')
	_arrow_behind = get_node('./arrow/arrow/arrow_behind')
	_arrow = get_node('./arrow');
	_label = get_node('./bubble/label');
	_center = get_node('/root/main_scene/center');

	_bubble_initial_pos = _bubble.global_position
	_bubble_distance_to_center_x = _bubble_initial_pos.x - _center.global_position.x

func _process(_delta):
	if talking_node == null:
		return

	global_position = talking_node.global_position;

	if global_position.x >= _center.global_position.x:
		_bubble.global_position = _bubble_initial_pos
		_arrow.scale.x = 1
		_arrow.global_position = global_position;
	else:
		_bubble.global_position = _bubble_initial_pos - Vector2(_bubble_distance_to_center_x * 2, 0)
		_arrow.scale.x = -1
		_arrow.global_position = global_position;

func set_theme(theme):
	if theme == 'digitized':
		_bubble_sprite.texture = speech_digitized;
		_bubble_behind.texture = speech_digitized_behind;
		_arrow_sprite.texture = arrow_digitized;
	else: 
		_bubble_sprite.texture = speech_bubble;
		_bubble_behind.texture = speech_bubble_behind;
		_arrow_sprite.texture = arrow_bubble;

func set_color(color):
	_bubble_behind.modulate = color;
	_arrow_behind.modulate = color;
	_label.modulate = color;



