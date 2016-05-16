/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void vs(Command cmd, Primitive main_prim, Layer main_layer) {
    vec2 pos = write_vertex(main_prim, main_layer);

    vImageUv = mix(main_prim.st.xy, main_prim.st.zw, aPosition.xy);

    Primitive rect_prim = primitives[cmd.prim_indices.y];
    vec3 rect_layer_pos = get_layer_pos(pos, cmd.layer_indices.y);
    vRectPos = rect_layer_pos;
    vRectColor = get_rect_color(rect_prim, rect_layer_pos);
    vRectRect = vec4(rect_prim.rect.xy, rect_prim.rect.xy + rect_prim.rect.zw);
}
