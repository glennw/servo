#line 1
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

struct Image {
    PrimitiveInfo info;
    vec4 local_rect;
    vec4 st_rect;
};

layout(std140) uniform Items {
    Image images[WR_MAX_PRIM_ITEMS];
};

void main(void) {
    Image image = images[gl_InstanceID];
    Layer layer = layers[image.info.layer_tile_part.x];
    Tile tile = tiles[image.info.layer_tile_part.y];

    vec2 local_pos = mix(image.local_rect.xy,
                         image.local_rect.xy + image.local_rect.zw,
                         aPosition.xy);

    vec4 world_pos = layer.transform * vec4(local_pos, 0, 1);

    vec2 device_pos = world_pos.xy * uDevicePixelRatio;

    vec2 clamped_pos = clamp(device_pos,
                             tile.actual_rect.xy,
                             tile.actual_rect.xy + tile.actual_rect.zw);

    vec4 local_clamped_pos = layer.inv_transform * vec4(clamped_pos / uDevicePixelRatio, 0, 1);

    vec2 f = (local_clamped_pos.xy - image.local_rect.xy) / image.local_rect.zw;

    vUv = mix(image.st_rect.xy,
              image.st_rect.zw,
              f);

    vec2 final_pos = clamped_pos + tile.target_rect.xy - tile.actual_rect.xy;

    gl_Position = uTransform * vec4(final_pos, 0, 1);
}
