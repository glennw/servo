/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    vec4 c0 = handle_prim(vInfo0, vColor0, vUv0);// * do_clip(vClipInfo0);
    vec4 c1 = handle_prim(vInfo1, vColor1, vUv1);// * do_clip(vClipInfo1);
    vec4 c2 = handle_prim(vInfo2, vColor2, vUv2);// * do_clip(vClipInfo2);
    oFragColor = mix(mix(c2, c1, c1.a), c0, c0.a);
}
