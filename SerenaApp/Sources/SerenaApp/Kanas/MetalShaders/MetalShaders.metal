#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 checkerboard(float2 position, half4 currentColor, float size, half4 newColor) {
    uint2 posInChecks = uint2(position.x / size, position.y / size);
    bool isColor = (posInChecks.x ^ posInChecks.y) & 1;
    return isColor ? newColor * currentColor.a : half4(0.0, 0.0, 0.0, 0.0);
}

[[ stitchable ]] half4 noise(float2 position, half4 currentColor, float time) {
    float value = fract(sin(dot(position + time, float2(12.9898, 78.233))) * 43758.5453);
    return half4(value, value, value, 1) * currentColor.a;
}
//
//[[ stitchable ]] half4 pixellate(float2 position, SwiftUI::Layer layer, float strength) {
//    float min_strength = max(strength, 0.0001);
//    float coord_x = min_strength * round(position.x / min_strength);
//    float coord_y = min_strength * round(position.y / min_strength);
//    return layer.sample(float2(coord_x, coord_y));
//}

//[[ stitchable ]] half4 pixellate(float2 position, SwiftUI::Layer layer, float maxStrength, float height) {
//    float y_ratio = position.y / height;
//    float strength = max(maxStrength * y_ratio, 0.0001);
//
//    float coord_x = strength * round(position.x / strength);
//    float coord_y = strength * round(position.y / strength);
//    return layer.sample(float2(coord_x, coord_y));
//}


[[ stitchable ]] half4 pixellate(float2 position, SwiftUI::Layer layer, float maxStrength, float globalYOrigin, float screenHeight) {
    float globalY = position.y + globalYOrigin; // global Y position of the pixel
    float y_strength = clamp(globalY / screenHeight - 0.8, 0.0, 1.0) * 5;

    y_strength = y_strength*y_strength*y_strength;
    float radius = 3 * y_strength;

    float2 offsets[13] = {
        float2( 0.0,  0.0), // center
        float2(-1.0,  0.0), float2( 1.0,  0.0), // horizontal
        float2( 0.0, -1.0), float2( 0.0,  1.0), // vertical
        float2(-1.0, -1.0), float2( 1.0, -1.0), // diagonals
        float2(-1.0,  1.0), float2( 1.0,  1.0),
        float2(-2.0,  0.0), float2( 2.0,  0.0), // second-ring horizontal
        float2( 0.0, -2.0), float2( 0.0,  2.0)  // second-ring vertical
    };


    half4 color = half4(0.0);
    for (int i = 0; i < 13; ++i) {
        float2 offset = offsets[i] * radius;
        color += layer.sample(position + offset);
    }
    color /= 13.0;
    color.a = color.a * (1 - clamp(y_strength/2, 0.0, 0.6));
    
    return color;
    
//    float coord_x = strength * round(position.x / strength);
//    float coord_y = strength * round(position.y / strength);
//    return layer.sample(float2(coord_x, coord_y));
}


[[ stitchable ]]
half4 verticalGlobalBlur(
    float2 position,
    SwiftUI::Layer layer,
    float blurRadius,
    float4 globalFrame
) {
    float globalY = position.y + globalFrame.y;      // position in global space
    float midY = globalFrame.y + globalFrame.w * 0.5; // global mid
    float maxY = globalFrame.y + globalFrame.w;       // global bottom

    float strength = clamp((globalY - midY) / (maxY - midY), 0.0, 1.0);
    float radius = blurRadius * strength;

    float2 offsets[5] = {
        float2( 0.0,  0.0),
        float2(-1.0,  0.0),
        float2( 1.0,  0.0),
        float2( 0.0, -1.0),
        float2( 0.0,  1.0)
    };

    half4 color = half4(0.0);
    for (int i = 0; i < 5; ++i) {
        float2 offset = offsets[i] * radius;
        color += layer.sample(position + offset);
    }

    return color / 5.0;
}

[[ stitchable ]] float2 simpleWave(float2 position, float time) {
//    return position + float2 (0, sin(time + position.x / 20)) * 10;
    return position + float2 (sin(time + position.y / 20), sin(time + position.x / 20)) * 5;
}

[[ stitchable ]] float2 complexWave(float2 position, float time, float2 size, float speed, float strength, float frequency) {
    float2 normalizedPosition = position / size;
    float moveAmount = time * speed;

    position.x += sin((normalizedPosition.x + moveAmount) * frequency) * strength;
    position.y += cos((normalizedPosition.y + moveAmount) * frequency) * strength;

    return position;
}

[[ stitchable ]] half4 emboss(float2 position, SwiftUI::Layer layer, float strength) {
    half4 current_color = layer.sample(position);
    half4 new_color = current_color;

    new_color += layer.sample(position + 1) * strength;
    new_color -= layer.sample(position - 1) * strength;

    return half4(new_color);
}


[[ stitchable ]]
half4 color(
    float2 position,
    half4 color
) {
    return half4(position.x/255.0, position.y/255.0, 0.0, 1.0);
}

[[ stitchable ]]
half4 sizeAwareColor(
    float2 position,
    half4 color,
    float2 size
) {
    return half4(position.x/size.x, position.y/size.y, position.x/size.y, 1.0);
}

float oscillate(float f) {
    return 0.5 * (sin(f) + 1);
}

[[ stitchable ]]
half4 timeVaryingColor(
    float2 position,
    half4 color,
    float2 size,
    float time
) {
    return half4(oscillate(2 * time + position.x/size.x),
                 oscillate(4 * time + position.y/size.y),
                 oscillate(-2 * time + position.x/size.y),
                 1.0);
}
