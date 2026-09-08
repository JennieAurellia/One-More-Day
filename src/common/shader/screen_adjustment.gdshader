shader_type canvas_item;

// Brightness: 0.0 = black, 1.0 = normal, 2.0 = double brightness
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

// Contrast: 0.0 = flat gray, 1.0 = normal, 2.0 = high contrast
uniform float contrast : hint_range(0.0, 2.0) = 1.0;

// Saturation: 0.0 = grayscale, 1.0 = normal, 2.0 = oversaturated
uniform float saturation : hint_range(0.0, 2.0) = 1.0;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 tex_color = texture(screen_texture, SCREEN_UV);

	// --- Brightness ---
	vec3 color = tex_color.rgb * brightness;

	// --- Contrast ---
	// Pivot around 0.5 gray so contrast scales outward from midpoint
	color = (color - 0.5) * contrast + 0.5;

	// --- Saturation ---
	// Blend between grayscale (luminance) and the full-color result
	float luminance = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(vec3(luminance), color, saturation);

	COLOR = vec4(color, tex_color.a);
}