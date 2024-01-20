shader_type canvas_item;

void fragment() {
	float time_mult = 1.7;
	float time = TIME * time_mult;
	//float x = sin(time) + cos(time * 0.7);
	//float y = sin(time) + cos(time);
	float x = time * 0.2 + sin(time) * 0.1;
	float y = - time;
	float magnitude = 0.3;
	
	vec2 uv = UV + vec2(x * magnitude, y * magnitude);
	COLOR = texture(TEXTURE, uv);
}