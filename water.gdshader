shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec3 shallow_color : source_color = vec3(0.1, 0.5, 0.7);
uniform vec3 deep_color    : source_color = vec3(0.02, 0.2, 0.35);
uniform float color_height_mix = 0.3;

uniform float wave_amp   : hint_range(0.0, 2.0) = 0.2;
uniform float wave_len   : hint_range(0.1, 64.0) = 8.0;
uniform float wave_speed : hint_range(0.0, 8.0) = 1.2;

uniform float roughness : hint_range(0.0, 1.0) = 0.05;
uniform float specular  : hint_range(0.0, 1.0) = 0.6;

varying vec3 world_pos;

void vertex() {
    vec2 xz = VERTEX.xz;
    float t = TIME * wave_speed;

    float wave = sin(dot(xz, vec2(1.0, 0.3)) / wave_len + t) +
                 0.7 * sin(dot(xz, vec2(0.5, 1.0)) / (wave_len*0.5) + t*1.3);

    VERTEX.y += wave * wave_amp;

    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    float h = clamp((world_pos.y * color_height_mix) + 0.5, 0.0, 1.0);
    vec3 base = mix(deep_color, shallow_color, h);

    float fresnel = pow(1.0 - max(dot(NORMAL, VIEW), 0.0), 3.0);

    ALBEDO = mix(base, vec3(1.0), fresnel * 0.3);
    SPECULAR = specular;
    ROUGHNESS = roughness;
    ALPHA = 0.85;
}
