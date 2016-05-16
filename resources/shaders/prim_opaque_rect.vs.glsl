/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void vs(Command cmd, Primitive main_prim, Layer main_layer) {
    vec2 pos = write_vertex(main_prim, main_layer);
	vec3 layer_pos = get_layer_pos(pos, cmd.layer_indices.x);
    vPrimColor0 = get_rect_color(main_prim, layer_pos);
}
