#line 1
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

struct Rectangle {
	PrimitiveInfo info;
	vec4 color;
};

layout(std140) uniform Items {
    Rectangle rects[1024];
};

void main(void) {
    Rectangle rect = rects[gl_InstanceID];
    Renderable renderable = renderables[rect.info.renderable_part.x];

    vec2 pos = mix(renderable.cache_rect.xy,
                   renderable.cache_rect.xy + renderable.cache_rect.zw,
                   aPosition.xy);

    gl_Position = uTransform * vec4(pos, 0.0, 1.0);

    vColor = rect.color;
}
