/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void vs(Command cmd, Primitive main_prim, Layer main_layer) {
    write_vertex(main_prim, main_layer);

    vPrimPos0.xy = mix(main_prim.st.xy, main_prim.st.zw, aPosition.xy);
}
