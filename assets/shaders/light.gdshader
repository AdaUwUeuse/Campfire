shader_type canvas_item;

const int MAX_LIGHTS = 16;

uniform int light_count;

uniform vec2 positions[MAX_LIGHTS];
uniform float radius[MAX_LIGHTS];
uniform float intensities[MAX_LIGHTS];
uniform vec4 colors[MAX_LIGHTS];

uniform float flicker_strength[MAX_LIGHTS];
uniform float flicker_speed[MAX_LIGHTS];
uniform float flicker_seed[MAX_LIGHTS];


float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(hash(i), hash(i + 1.0), u);
}

float fbm(float x)
{
    float v = 0.0;
    float a = 0.5;

    for (int i = 0; i < 3; i++) {
        v += noise(x) * a;
        x *= 2.0;
        a *= 0.5;
    }

    return v;
}

void fragment()
{
    vec2 uv = SCREEN_UV;
    vec2 aspect = vec2(SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y, 1.0);

    float total_intensity = 0.0;
    vec3 weighted_color = vec3(0.0);

    for (int i = 0; i < light_count; i++)
    {
        vec2 diff = (uv - positions[i]) / aspect;
        float d = length(diff);

        float falloff = 1.0 - smoothstep(0.0, radius[i], d);

        float flicker = 1.0;

        float n = fbm(TIME * flicker_speed[i] + flicker_seed[i]);
        flicker += (n - 0.5) * flicker_strength[i];

        float contribution = falloff * intensities[i] * flicker;

        total_intensity += contribution;
        weighted_color += colors[i].rgb * contribution;
    }

    total_intensity = clamp(total_intensity, 0.0, 1.0);

    vec3 mixed_color = vec3(1.0);
    if (total_intensity > 0.0)
        mixed_color = weighted_color / total_intensity;

    float whiteness = dot(mixed_color, vec3(0.299, 0.587, 0.114));

    float alpha = 1.0 - total_intensity * whiteness;
    alpha = clamp(alpha, 0.0, 1.0);

    vec3 tint = mixed_color * total_intensity * (1.0 - whiteness) * 0.35;

    COLOR = vec4(tint, alpha);
}