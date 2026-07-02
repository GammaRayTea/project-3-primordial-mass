shader_type spatial;
render_mode unshaded;

uniform sampler2D original_texture: source_color, filter_nearest;
uniform sampler2D screen_texture: hint_screen_texture, filter_linear;
uniform float pixel_noise_size: hint_range(0.0, 256.0, 1.0) = 64.0;
uniform float speed: hint_range(0.0, 1.0, 0.00001) = 0.00005;
uniform bool moving = true;
uniform float pixel_brightness_shift: hint_range(0.0, 5.0, 0.1) = 1.0;

float hash(vec2 _input) {
	_input = fract(_input * vec2(24.33, 143.23));
	_input += (_input * (_input + 34.32));
	float hash = fract(_input.x * _input.y);
	return hash;
}

void fragment() {
	if(moving == true){
		vec2 uv_grid = floor(UV * pixel_noise_size) / pixel_noise_size;
		float n = hash(uv_grid + vec2(TIME * speed, 0.0));
		
		vec4 passthrough = texture(screen_texture, SCREEN_UV);
		ALBEDO = passthrough.rgb * (n + pixel_brightness_shift);
		vec4 tex_color = texture(original_texture, UV);
		ALPHA = tex_color.a;
	}
	else{
		ALPHA = 0.0;
	}
}
