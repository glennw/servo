/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void vs(Command cmd, Primitive main_prim, Layer main_layer) {
    vec2 pos = write_vertex(main_prim, main_layer);

    write_generic(cmd.prim_indices.x,
                  cmd.layer_indices.x,
                  cmd.clip_info.x,
                  pos,
                  vPrimPos0,
                  vPrimColor0,
                  vPrimRect0);
    write_generic(cmd.prim_indices.y,
                  cmd.layer_indices.y,
                  INVALID_CLIP_INDEX,
                  pos,
                  vPrimPos1,
                  vPrimColor1,
                  vPrimRect1);
    write_generic(cmd.prim_indices.z,
                  cmd.layer_indices.z,
                  INVALID_CLIP_INDEX,
                  pos,
                  vPrimPos2,
                  vPrimColor2,
                  vPrimRect2);
    write_generic(cmd.prim_indices.w,
                  cmd.layer_indices.w,
                  INVALID_CLIP_INDEX,
                  pos,
                  vPrimPos3,
                  vPrimColor3,
                  vPrimRect3);

    write_clip(cmd.clip_info.x, vClipRect, vClipParams);
    vClipPos = pos;
}
