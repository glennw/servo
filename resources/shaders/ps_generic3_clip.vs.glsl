/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void vs(Command cmd, vec2 layer_pos) {
    write_generic(cmd.prim_indices.x,
                  layer_pos,
                  vUv0,
                  vColor0,
                  vInfo0);

    write_generic(cmd.prim_indices.y,
    			  layer_pos,
                  vUv1,
                  vColor1,
                  vInfo1);

    write_generic(cmd.prim_indices.z,
                  layer_pos,
                  vUv2,
                  vColor2,
                  vInfo2);

    write_clip(layer_pos, primitives[cmd.prim_indices.x], vClipInfo0);
    write_clip(layer_pos, primitives[cmd.prim_indices.y], vClipInfo1);
    write_clip(layer_pos, primitives[cmd.prim_indices.z], vClipInfo2);
}
