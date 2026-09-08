shader_type canvas_item;

// How strong the vignette darkening/tinting is. 0.0 = no effect, 1.0 = full effect
uniform float intensity : hint_range(0.0, 1.0) = 0.5;

// How far from the center the vignette starts (0.0 = center, 1.0 = edge)
uniform float radius : hint_range(0.0, 1.5) = 0.75;

// How gradual the falloff is. Lower = sharper edge, higher = smoother blend
uniform float softness : hint_range(0.01, 1.5) = 0.5;

// Color of the vignette (usually black, but can be tinted e.g. for a "blood" or sepia effect)
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Aspect ratio correction so the vignette is circular instead of stretched on non-square screens
uniform bool round_shape = true;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 tex_color = texture(screen_texture, SCREEN_UV);

	// Center the UV coords around (0,0), ranging roughly -0.5 to 0.5
	vec2 uv = SCREEN_UV - vec2(0.5);

	if (round_shape) {
		// Correct for aspect ratio so the vignette is a circle, not an ellipse
		uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	}

	float dist = length(uv);

	// smoothstep from (radius) to (radius + softness) creates the falloff ring
	float vignette_amount = smoothstep(radius, radius + softness, dist);
	vignette_amount *= intensity;

	vec3 color = mix(tex_color.rgb, vignette_color.rgb, vignette_amount * vignette_color.a);

	COLOR = vec4(color, tex_color.a);
}