shader_type spatial;
render_mode depth_draw_opaque, depth_prepass_alpha; //Settings needed to cast a shadow

// Overall settings
uniform bool enabled = true; // enable/disable
uniform sampler2D sprite_texture : source_color, filter_nearest; // set this in editor
uniform bool billboard = true; // switch modes

// Outline customization
//use rgb values > 1 to get HDR glow from a WorldEnvironment node
instance uniform vec4 color : source_color = vec4(11.0, 11.0, 25.0, 0.1); // outline rgba
uniform float line_thickness : hint_range(0.0, 20.0) = 1.0; //Works best under 10
uniform float rings: hint_range(0.0, 10.0, 1.0) = 2;

//4 directions for offset
const vec2 OFFSETS[4] = {
	vec2(0, 1), vec2(0, -1), vec2(1, 0), vec2(-1, 0)
};

varying vec2 texture_size;
varying vec2 out_size;
varying float padding;


void vertex() {
	texture_size = vec2(textureSize(sprite_texture, 0));
	padding = line_thickness + rings;
	out_size = texture_size + padding * 2.0;
	
	vec2 texture_pixel_size = 1.0 / texture_size;
	VERTEX.xy += (UV * 2.0 - 1.0) * vec2(padding, -padding) * texture_pixel_size;
	
	if (billboard) {
		mat4 modified_model_view = VIEW_MATRIX * mat4(
			INV_VIEW_MATRIX[0],
			INV_VIEW_MATRIX[1],
			INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]
		);
		MODELVIEW_MATRIX = modified_model_view;
	}
}

vec4 sample_padded(vec2 _uv_padded, vec2 _texture_size, vec2 _out_size, float _pad) {
	vec2 pixel_pos = _uv_padded * _out_size - _pad;
	if (pixel_pos.x < 0.0 || pixel_pos.y < 0.0 || pixel_pos.x >= _texture_size.x || pixel_pos.y >= _texture_size.y) {
		return vec4(0.0);
	}
	vec2 src_uv = (pixel_pos + 0.5) / _texture_size;
	return texture(sprite_texture, src_uv);
}

void fragment() {
	vec4 tex = sample_padded(UV, texture_size, out_size, padding);
	vec4 emission = vec4(0.0);
	
	if (enabled && line_thickness >= 0.1) {
		vec2 padded_pixel_size = 1.0 / out_size;
		vec2 line_size = padded_pixel_size * line_thickness;
		
		float outline = 0.0;
		for (int i = 0; i < 4; i++) {
			vec2 coords = UV + line_size * OFFSETS[i];
			outline += sample_padded(coords, texture_size, out_size, padding).a;
		}
		outline = min(outline, 1.0);
		tex = mix(tex, color, outline - ceil(tex.a));
		emission = mix(vec4(0.0), color, outline - ceil(tex.a));
	}
	ALBEDO = tex.rgb;
	EMISSION = emission.rgb;
	ALPHA = tex.a;
}