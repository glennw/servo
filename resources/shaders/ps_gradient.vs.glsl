#line 1
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#define DIR_HORIZONTAL      uint(0)
#define DIR_VERTICAL        uint(1)

struct Gradient {
	PrimitiveInfo info;
    vec4 local_rect;
    vec4 color0;
    vec4 color1;
    uvec4 dir;
};

layout(std140) uniform Items {
    Gradient gradients[512];
};

void main(void) {
    Gradient gradient = gradients[gl_InstanceID];
    Renderable renderable = renderables[gradient.info.renderable_part.x];

    // local prim rect pos
    vec2 p0 = gradient.local_rect.xy;
    vec2 p1 = p0 + gradient.local_rect.zw;
    vec2 local_pos = mix(p0, p1, aPosition.xy);

    // Interpolate within the subrect of the stacking context.
    local_pos = clamp(local_pos,
                      renderable.local_rect.xy,
                      renderable.local_rect.xy + renderable.local_rect.zw);

    vec2 f = (local_pos - p0) / gradient.local_rect.zw;

    switch (gradient.dir.x) {
        case DIR_HORIZONTAL:
            vF = f.x;
            break;
        case DIR_VERTICAL:
            vF = f.y;
            break;
    }

    vColor0 = gradient.color0;
    vColor1 = gradient.color1;

    vec4 pos = renderable.transform * vec4(local_pos, 0, 1);

    // offset in cache texture and clip
    pos.xy *= uDevicePixelRatio;
    pos.xy -= renderable.screen_rect.xy;
    pos.xy += renderable.cache_rect.xy;
    pos.xy = clamp(pos.xy,
                   renderable.cache_rect.xy,
                   renderable.cache_rect.xy + renderable.cache_rect.zw);

    gl_Position = uTransform * vec4(pos.xy, 0.0, 1.0);
}
