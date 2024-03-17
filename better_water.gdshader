shader_type canvas_item;

uniform vec4 tint : source_color;
uniform vec2 sprite_scale = vec2(10.0);
uniform float scale_x = 0.1;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float rand(vec2 coord){
 return fract(sin(dot(coord, vec2(12.9898, 78.233)))* 43758.5453123);
}

float noise(vec2 coord){
 vec2 i = floor(coord);
 vec2 f = fract(coord);

 // 4 corners of a rectangle surrounding our point
 float a = rand(i);
 float b = rand(i + vec2(1.0, 0.0));
 float c = rand(i + vec2(0.0, 1.0));
 float d = rand(i + vec2(1.0, 1.0));

 vec2 cubic = f * f * (3.0 - 2.0 * f);

 return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

void fragment(){
	vec2 newuv = UV;
	newuv += vec2(TIME * -0.1, TIME * 0.05);

	vec2 noisecoord1 = UV * sprite_scale * scale_x;
	vec2 noisecoord2 = UV * sprite_scale * scale_x + 4.0;

	vec2 motion1 = vec2(TIME * 3.0, TIME * 10.0);
	vec2 motion2 = vec2(TIME * 0.1, TIME * 10.5);

	vec2 distort1 = vec2(noise(noisecoord1 + motion1), noise(noisecoord2 + motion1)) - vec2(0.5);
	vec2 distort2 = vec2(noise(noisecoord1 + motion2), noise(noisecoord2 + motion2)) - vec2(0.5);

	vec2 distort_sum = (distort1 + distort2) / 60.0;

	vec4 alpha_tex = texture(SCREEN_TEXTURE, SCREEN_UV + distort_sum) * vec4(1., 1., 1., 0.9);

	vec4 mixed = mix(alpha_tex, tint, 0.3);

	//vec4 c = ;
	COLOR = mixed;
}