#line 1
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

struct Border {
    PrimitiveInfo info;
    vec4 local_rect;
    vec4 color0;
    vec4 color1;
    vec4 radii;
};

layout(std140) uniform Items {
    Border borders[200];
};

void main(void) {
    Border border = borders[gl_InstanceID];
    Layer layer = layers[border.info.layer_tile_part.x];
    Tile tile = tiles[border.info.layer_tile_part.y];

    vec2 local_pos = mix(border.local_rect.xy,
                         border.local_rect.xy + border.local_rect.zw,
                         aPosition.xy);

    vec4 world_pos = layer.transform * vec4(local_pos, 0, 1);

    vec2 device_pos = world_pos.xy * uDevicePixelRatio;

    vec2 clamped_pos = clamp(device_pos,
                             tile.actual_rect.xy,
                             tile.actual_rect.xy + tile.actual_rect.zw);

    vec2 final_pos = clamped_pos + tile.target_rect.xy - tile.actual_rect.xy;

    gl_Position = uTransform * vec4(final_pos, 0, 1);

    float w = border.local_rect.z;
    float h = border.local_rect.w;
    float x0, y0, x1, y1;
    switch (border.info.layer_tile_part.z) {
        case PST_TOP_LEFT:
            x0 = border.local_rect.x;
            y0 = border.local_rect.y;
            x1 = border.local_rect.x + border.local_rect.z;
            y1 = border.local_rect.y + border.local_rect.w;
            break;
        case PST_TOP_RIGHT:
            x0 = border.local_rect.x + border.local_rect.z;
            y0 = border.local_rect.y;
            x1 = border.local_rect.x;
            y1 = border.local_rect.y + border.local_rect.w;
            break;
        case PST_BOTTOM_LEFT:
            x0 = border.local_rect.x;
            y0 = border.local_rect.y + border.local_rect.w;
            x1 = border.local_rect.x + border.local_rect.z;
            y1 = border.local_rect.y;
            break;
        case PST_BOTTOM_RIGHT:
            x0 = border.local_rect.x;
            y0 = border.local_rect.y;
            x1 = border.local_rect.x + border.local_rect.z;
            y1 = border.local_rect.y + border.local_rect.w;
            break;
        case PST_TOP:
        case PST_LEFT:
        case PST_BOTTOM:
        case PST_RIGHT:
            x0 = border.local_rect.x;
            y0 = border.local_rect.y;
            x1 = border.local_rect.x + border.local_rect.z;
            y1 = border.local_rect.y + border.local_rect.w;
            break;
    }
    vF = (local_pos.x - x0) * (y1 - y0) - (local_pos.y - y0) * (x1 - x0);

    vColor0 = border.color0;
    vColor1 = border.color1;
    vRadii = border.radii;
    vRefPoint = border.local_rect.xy + vRadii.xy;
    vPos = local_pos.xy;
}
