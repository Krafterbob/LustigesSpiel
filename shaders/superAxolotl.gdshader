shader_type canvas_item;

uniform bool active = true;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec4 pixelColor = texture(TEXTURE, UV);

	if (active) {
		vec4 outline = vec4(1,1,1,
					max(max(max(texture(TEXTURE, vec2(UV.x, UV.y + SCREEN_PIXEL_SIZE.y * 20.0)).a,
					texture(TEXTURE, vec2(UV.x, UV.y - SCREEN_PIXEL_SIZE.y * 20.0)).a),
					texture(TEXTURE, vec2(UV.x - SCREEN_PIXEL_SIZE.x * 20.0, UV.y)).a),
					texture(TEXTURE, vec2(UV.x + SCREEN_PIXEL_SIZE.x * 20.0, UV.y)).a));
		vec4 pixelColor;
		if (texture(TEXTURE, UV).a == 0.0) {
			pixelColor = vec4(abs(sin(TIME + UV.x)), abs(cos(TIME + UV.y)), abs(tan(TIME + UV.x)), 1.0) * outline;
			COLOR = pixelColor;
		}
		else {
			pixelColor = mix(texture(TEXTURE, UV), vec4(abs(sin(TIME + UV.x)), abs(cos(TIME + UV.y)), abs(tan(TIME + UV.x)), 1.0), 0.1);
			COLOR *= mix(vec4(1,1,1,1), vec4(abs(sin(TIME + UV.x)), abs(cos(TIME + UV.y)), abs(tan(TIME + UV.x)), 1.0), 0.1);
		}
	}
}
