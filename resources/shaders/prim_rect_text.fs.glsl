/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    vec4 text_color = vec4(vPrimColor0.rgb, vPrimColor0.a * texture(sMask, vPrimPos0.xy).a);

    vec2 rect_pos = vPrimPos1.xy / vPrimPos1.z;
    vec4 rect_rect = vPrimRect1;

    vec4 rect_color = vec4(1,1,1,1);
    if (point_in_rect(rect_pos, rect_rect.xy, rect_rect.zw)) {
        rect_color = vPrimColor1;
    }

    oFragColor = mix(rect_color, text_color, text_color.a);
}
