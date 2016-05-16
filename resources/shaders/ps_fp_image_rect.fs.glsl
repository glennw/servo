/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    vec4 image_color = texture(sDiffuse, vImageUv);

    vec4 rect_color = vec4(1,1,1,1);
    if (point_in_rect(vRectPos.xy, vRectRect.xy, vRectRect.zw)) {
        rect_color = vRectColor;
    }

    oFragColor = mix(rect_color, image_color, image_color.a);
}
