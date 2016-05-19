/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

struct Glyph {
    vec4 p0_p1;
    vec4 st0_st1;
};

layout(std140) uniform Glyphs {
    Glyph glyphs[1024];
};

void main(void)
{
    Glyph glyph = glyphs[gl_InstanceID];

    vec2 pos = mix(glyph.p0_p1.xy, glyph.p0_p1.zw, aPosition.xy);
    gl_Position = uTransform * vec4(pos, 0.0, 1.0);

    vColorTexCoord = mix(glyph.st0_st1.xy, glyph.st0_st1.zw, aPosition.xy);
}

