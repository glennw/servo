/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void vs(Command cmd, Primitive main_prim, Layer main_layer) {
    vec2 pos = write_vertex(main_prim, main_layer);

    vPrimPos0.xy = mix(main_prim.st.xy, main_prim.st.zw, aPosition.xy);
    vPrimColor0 = main_prim.color0;

    write_rect(cmd.prim_indices.y,
    		   cmd.layer_indices.y,
    		   pos,
    		   vPrimPos1.xyz,
    		   vPrimColor1,
    		   vPrimRect1);
}
