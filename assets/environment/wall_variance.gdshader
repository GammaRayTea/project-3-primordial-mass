shader_type spatial;

uniform sampler2D default_texture:filter_nearest,source_color;
uniform sampler2D texture2:filter_nearest,source_color;
uniform sampler2D texture3:filter_nearest,source_color;
uniform sampler2D texture4:filter_nearest,source_color;
varying flat int texture_index;
varying vec3 vertex_color;
void vertex() {
	
		
	if (COLOR.b > 0.0) {
		if (COLOR.a <1.0) {
			texture_index = 3;
		}
		else {
			texture_index = 2;
		}
	}
	else {
		if (COLOR.a < 1.0) {
			texture_index = 1;
		}
		else {
			texture_index = 0;
		}
		
	}
	vertex_color = COLOR.aaa;
}
void fragment() {
	vec4 final_texture;
	if (texture_index == 0) {
		final_texture = texture(default_texture,UV);
	}
		
	else if (texture_index == 1) {
		final_texture = texture(texture2,UV);
	}
		
	else if (texture_index == 2) {
		final_texture = texture(texture3,UV);
	}
	else if (texture_index == 3){
		final_texture = texture(texture4,UV);
	}

	ALBEDO = final_texture.rgb;
	//ALBEDO = vertex_color;
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
