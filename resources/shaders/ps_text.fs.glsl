/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    vec4 result = fetch_initial_color();
    vec4 prim_color = vec4(vColor.rgb, vColor.a * texture(sMask, vUv).a);
    oFragColor = mix(result, prim_color, prim_color.a);
}
