/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    vec2 pos = vPos.xy / vPos.z;

    if (point_in_rect(pos, vRect.xy, vRect.xy + vRect.zw)) {
        oFragColor = vec4(0,1,0,1);
        return;
    }

    oFragColor = vColor;
}
