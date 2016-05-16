/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void) {
    vec4 result = fetch_initial_color();

    vec4 prim_color = handle_prim(vPrimPos1, vPrimColor1, vPrimRect1);
    result = mix(result, prim_color, prim_color.a);

    prim_color = handle_prim(vPrimPos2, vPrimColor2, vPrimRect2);
    result = mix(result, prim_color, prim_color.a);

    prim_color = handle_prim(vPrimPos3, vPrimColor3, vPrimRect3);
    result = mix(result, prim_color, prim_color.a);

    vec4 main_color = handle_prim(vPrimPos0, vPrimColor0, vPrimRect0);
    result = mix(result, main_color, main_color.a);

    oFragColor = result;
}
