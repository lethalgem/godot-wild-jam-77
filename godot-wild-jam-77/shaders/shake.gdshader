shader_type canvas_item;

// Time parameter to control animations
uniform float time : hint_range(0.0, 100.0); // Input the current time (passed from a script).

// Shake effect parameters
uniform float shake_intensity : hint_range(0.0, 20.0) = 5.0; // How much to shake.
uniform float shake_speed : hint_range(0.1, 50.0) = 10.0; // Speed of the shake.

// Grow and shrink effect parameters
uniform float grow_shrink_speed : hint_range(0.1, 10.0) = 2.0; // Speed of growing and shrinking.
uniform float grow_shrink_amount : hint_range(0.0, 2.0) = 0.3; // How much to grow and shrink.

// Noise seed parameter for shake randomness
uniform float noise_seed : hint_range(0.0, 1.0) = 0.5; // Controls pseudo-random shake patterns.

void fragment() {
    // Calculate the shake offset using a pseudo-random pattern.
    float shake_offset_x = sin(time * shake_speed + UV.x * noise_seed) * shake_intensity;
    float shake_offset_y = cos(time * shake_speed + UV.y * noise_seed) * shake_intensity;

    // Calculate the grow and shrink scale factor
    float scale_factor = 1.0 + sin(time * grow_shrink_speed) * grow_shrink_amount;

    // Apply the transformations
    vec2 new_uv = (UV - vec2(0.5)) * scale_factor + vec2(0.5) + vec2(shake_offset_x, shake_offset_y);

    // Set the final color
    COLOR = texture(TEXTURE, new_uv);
}