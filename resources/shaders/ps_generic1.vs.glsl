/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void vs(Command cmd, vec2 layer_pos) {
    write_generic(cmd.prim_indices.x,
    			  layer_pos,
                  vUv,
                  vColor,
                  vInfo);
}
