#line 1

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

//======================================================================================
// Vertex shader attributes and uniforms
//======================================================================================
#ifdef WR_VERTEX_SHADER
    uniform int uCmdOffset;
#endif

//======================================================================================
// Fragment shader attributes and uniforms
//======================================================================================
#ifdef WR_FRAGMENT_SHADER
#endif

//======================================================================================
// Shared uniforms
//======================================================================================
varying vec4 vLayerPos;
varying vec4 vBlendInfo;        // TODO(gw): This can probably be packed
                                // into vLayerPos if we start running out of interpolators...

//======================================================================================
// Interpolator definitions
//======================================================================================

//======================================================================================
// Shared types and constants
//======================================================================================
#define PRIM_KIND_RECT              uint(0)
#define PRIM_KIND_IMAGE             uint(1)
#define PRIM_KIND_TEXT              uint(2)
#define PRIM_KIND_BORDER_CORNER     uint(3)
#define PRIM_KIND_INVALID           uint(4)

//======================================================================================
// Shared types and UBOs
//======================================================================================

//======================================================================================
// VS only types and UBOs
//======================================================================================
#ifdef WR_VERTEX_SHADER

#define RECT_KIND_SOLID                     uint(0)
#define RECT_KIND_HORIZONTAL_GRADIENT       uint(1)
#define RECT_KIND_VERTICAL_GRADIENT         uint(2)
#define RECT_KIND_BOX_SHADOW_EDGE           uint(3)

#define CLIP_CORNER_TOP_LEFT                uint(0)
#define CLIP_CORNER_TOP_RIGHT               uint(1)
#define CLIP_CORNER_BOTTOM_LEFT             uint(2)
#define CLIP_CORNER_BOTTOM_RIGHT            uint(3)

struct ClipInfo {
    vec4 ref_point_and_width;
    vec4 outer_inner_radii;
};

struct Primitive {
    vec4 rect;
    vec4 st;
    vec4 color0;
    vec4 color1;
    uvec4 info;
    ClipInfo clip;
};

struct Layer {
    mat4 transform;
    mat4 inv_transform;
    vec4 screen_vertices[4];
    vec4 blend_info;
};

struct Command {
    vec4 tile_rect;
    uvec4 info;
    uvec4 prim_indices;
};

/*
struct ClipCorner {
    vec4 rect;
    vec4 outer_inner_radii;
};

struct Clip {
    vec4 p0_p1;
    uvec4 flags;
    ClipCorner top_left;
    ClipCorner top_right;
    ClipCorner bottom_left;
    ClipCorner bottom_right;
};*/

layout(std140) uniform Layers {
    Layer layers[315];
};

layout(std140) uniform Commands {
    Command commands[1365];
};

layout(std140) uniform Primitives {
    Primitive primitives[585];
};

/*
layout(std140) uniform Clips {
    Clip clips[256];
};*/

#endif

//======================================================================================
// Shared functions
//======================================================================================

//======================================================================================
// VS only functions
//======================================================================================
#ifdef WR_VERTEX_SHADER

#define INVALID_PRIM_INDEX      uint(0xffffffff)
#define INVALID_CLIP_INDEX      uint(0xffffffff)

#define PRIM_ROTATION_0         uint(0)
#define PRIM_ROTATION_90        uint(1)
#define PRIM_ROTATION_180       uint(2)
#define PRIM_ROTATION_270       uint(3)

/*
void write_clip(uint clip_index,
                out vec4 clip_rect,
                out vec4 clip_params) {
    if (clip_index == INVALID_CLIP_INDEX) {
        clip_rect = vec4(-9e9f, -9e9f, 9e9f, 9e9f);
        clip_params = vec4(0, 0, 0, 0);
    } else {
        Clip clip = clips[clip_index];
        clip_rect = clip.p0_p1;
        clip_params = vec4(clip.top_left.outer_inner_radii.x,
                           clip.top_right.outer_inner_radii.x,
                           clip.bottom_left.outer_inner_radii.x,
                           clip.bottom_right.outer_inner_radii.x);
    }
}

void write_border_clip(uint clip_index,
                       uint rotation,
                       out vec4 clip_params) {
    Clip clip = clips[clip_index];
    switch (rotation) {
        case PRIM_ROTATION_0: {
            clip_params = vec4(clip.top_left.rect.xy + clip.top_left.rect.zw,
                               clip.top_left.outer_inner_radii.xz);
            break;
        }
        case PRIM_ROTATION_90: {
            clip_params = vec4((clip.top_right.rect.xy + vec2(0.0, clip.top_right.rect.w)) * vec2(-1.0, 1.0),
                               clip.top_right.outer_inner_radii.xz);
            break;
        }
        case PRIM_ROTATION_180: {
            clip_params = vec4(clip.bottom_right.rect.xy * vec2(-1.0, -1.0),
                               clip.bottom_right.outer_inner_radii.xz);
            break;
        }
        case PRIM_ROTATION_270: {
            clip_params = vec4((clip.bottom_left.rect.xy + vec2(clip.bottom_left.rect.z, 0.0)) * vec2(1.0, -1.0),
                               clip.bottom_left.outer_inner_radii.xz);
            break;
        }
    }
}

bool ray_plane(vec3 normal, vec3 point, vec3 ray_origin, vec3 ray_dir, out float t)
{
    float denom = dot(normal, ray_dir);
    if (denom > 1e-6) {
        vec3 d = point - ray_origin;
        t = dot(d, normal) / denom;
        return t >= 0.0;
    }

    return false;
}

vec4 untransform(vec2 ref, vec3 n, vec3 a, mat4 inv_transform) {
    vec3 p = vec3(ref, -10000.0);
    vec3 d = vec3(0, 0, 1.0);

    float t;
    ray_plane(n, a, p, d, t);
    vec3 c = p + d * t;

    vec4 r = inv_transform * vec4(c, 1.0);
    return vec4(r.xyz / r.w, r.w);
}

vec3 get_layer_pos(vec2 pos, uint layer_index) {
    Layer layer = layers[layer_index];
    vec3 a = layer.screen_vertices[0].xyz / layer.screen_vertices[0].w;
    vec3 b = layer.screen_vertices[3].xyz / layer.screen_vertices[3].w;
    vec3 c = layer.screen_vertices[2].xyz / layer.screen_vertices[2].w;
    vec3 n = normalize(cross(b-a, c-a));
    vec4 local_pos = untransform(pos, n, a, layer.inv_transform);
    return local_pos.xyw;
}
*/

void write_clip(vec2 layer_pos,
                Primitive prim,
                out vec4 clip_info) {
    clip_info = vec4(prim.clip.ref_point_and_width.xy,
                     prim.clip.outer_inner_radii.xz);

    //clip_info = vec4(100.0, 100.0, 50.0, 0.0);
    /*
    if (prim.clip_info.x == INVALID_CLIP_INDEX) {
        clip_info = vec4(9e9f, 0, 0, 0);
    } else {
        Clip clip = clips[prim.clip_info.x];
        switch (prim.clip_info.y) {
            case CLIP_CORNER_TOP_LEFT:
                clip_info = vec4(clip.top_left.outer_inner_radii.xy / prim.rect.zw,
                                 clip.top_left.outer_inner_radii.zw / prim.rect.zw);
                break;
            case CLIP_CORNER_TOP_RIGHT:
                clip_info = vec4(clip.top_right.outer_inner_radii.xy / prim.rect.zw,
                                 clip.top_right.outer_inner_radii.zw / prim.rect.zw);
                clip_info.x = -clip_info.x;
                break;
            case CLIP_CORNER_BOTTOM_LEFT:
                clip_info = vec4(clip.bottom_left.outer_inner_radii.xy / prim.rect.zw,
                                 clip.bottom_left.outer_inner_radii.zw / prim.rect.zw);
                clip_info.y = -clip_info.y;
                break;
            case CLIP_CORNER_BOTTOM_RIGHT:
                clip_info = vec4(clip.bottom_right.outer_inner_radii.xy / prim.rect.zw,
                                 clip.bottom_right.outer_inner_radii.zw / prim.rect.zw);
                clip_info.x = -clip_info.x;
                clip_info.y = -clip_info.y;
                break;
        }
    }*/
}

vec4 get_rect_color(Primitive prim, vec2 f) {
    vec4 result;

    switch (prim.info.y) {
        case RECT_KIND_SOLID: {
            result = prim.color0;
            break;
        }
        case RECT_KIND_HORIZONTAL_GRADIENT: {
            result = mix(prim.color0, prim.color1, f.x);
            break;
        }
        case RECT_KIND_VERTICAL_GRADIENT: {
            result = mix(prim.color0, prim.color1, f.y);
            break;
        }
    }

    return result;
}

void write_generic(uint prim_index,
                   vec2 layer_pos,
                   out vec4 out_uv,
                   out vec4 out_color,
                   out vec4 out_info) {
    if (prim_index == INVALID_PRIM_INDEX) {
        out_info.x = PRIM_KIND_INVALID;
    } else {
        Primitive prim = primitives[prim_index];
        uint prim_kind = prim.info.x;
        out_info.x = prim_kind;

        vec2 f = (layer_pos - prim.rect.xy) / prim.rect.zw;

        switch (prim_kind) {
            case PRIM_KIND_RECT:
                out_color = get_rect_color(prim, f);
                break;
            case PRIM_KIND_TEXT:
            case PRIM_KIND_IMAGE:
                {
                    vec2 st0 = prim.st.xy;
                    vec2 st1 = prim.st.zw;

                    switch (prim.info.z) {
                        case PRIM_ROTATION_0:
                            break;
                        case PRIM_ROTATION_90:
                            f = vec2(f.y, f.x);
                            st0 = prim.st.xw;
                            st1 = prim.st.zy;
                            break;
                        case PRIM_ROTATION_180:
                            st0 = prim.st.zw;
                            st1 = prim.st.xy;
                            break;
                        case PRIM_ROTATION_270:
                            f = vec2(f.y, f.x);
                            st0 = prim.st.zy;
                            st1 = prim.st.xw;
                            break;
                    }

                    out_color = prim.color0;
                    out_uv.xy = mix(st0, st1, f);
                }
                break;
            case PRIM_KIND_BORDER_CORNER:
                {
                    switch (prim.info.z) {
                        case PRIM_ROTATION_0:
                            out_info.zw = vec2(f.y, f.x);
                            break;
                        case PRIM_ROTATION_90:
                            out_info.zw = vec2(1.0 - f.x, f.y);
                            break;
                        case PRIM_ROTATION_180:
                            out_info.zw = vec2(f.x, f.y);
                            break;
                        case PRIM_ROTATION_270:
                            out_info.zw = vec2(f.x, 1.0 - f.y);
                            break;
                    }
                    out_uv = prim.color0;
                    out_color = prim.color1;
                }
                break;
        }
    }
}

/*
// TODO(gw): Re-work this so that not all generic prim paths pay this cost? (Maybe irrelevant since it's a VS cost only)
vec2 write_vertex(Primitive prim, Layer layer) {
    vec2 local_pos = aPosition.xy;

    switch (prim.info.y) {
        case RECT_KIND_BORDER_CORNER: {
            switch (prim.info.z) {
                case PRIM_ROTATION_0: {
                    local_pos.y = 1.0 - local_pos.y;
                    break;
                }
                case PRIM_ROTATION_90: {
                    break;
                }
                case PRIM_ROTATION_180: {
                    local_pos.x = 1.0 - local_pos.x;
                    break;
                }
                case PRIM_ROTATION_270: {
                    local_pos.x = 1.0 - local_pos.x;
                    local_pos.y = 1.0 - local_pos.y;
                    break;
                }
            }
            break;
        }
        case RECT_KIND_BOX_SHADOW_EDGE: {
            switch (prim.info.z) {
                case PRIM_ROTATION_0: {
                    break;
                }
                case PRIM_ROTATION_90: {
                    local_pos.x = 1.0 - aPosition.y;
                    local_pos.y = aPosition.x;
                    break;
                }
                case PRIM_ROTATION_180: {
                    local_pos.x = 1.0 - aPosition.x;
                    local_pos.y = 1.0 - aPosition.y;
                    break;
                }
                case PRIM_ROTATION_270: {
                    local_pos.x = aPosition.y;
                    local_pos.y = 1.0 - aPosition.x;
                    break;
                }
            }
            break;
        }
    }

    vec2 p0 = prim.rect.xy;
    vec2 p1 = prim.rect.xy + prim.rect.zw;
    vec4 pos = layer.transform * vec4(mix(p0, p1, local_pos), 0, 1);

    switch (prim.info.x) {
        case PRIM_KIND_TEXT: {
            pos = round(pos * uDevicePixelRatio) / uDevicePixelRatio;
            break;
        }
    }

    gl_Position = uTransform * pos;
    return pos.xy / pos.w;
}
*/

void vs(Command cmd, vec2 layer_pos);

void main() {
    Command cmd = commands[gl_InstanceID + uCmdOffset];

    uint layer_index = cmd.info.x;
    Layer layer = layers[layer_index];

    vec2 local_pos = mix(cmd.tile_rect.xy, cmd.tile_rect.zw, aPosition.xy);
    vec4 pos = layer.transform * vec4(local_pos, 0, 1);

    uint prim_index = cmd.prim_indices.x;
    Primitive prim = primitives[prim_index];
    vec2 f = (local_pos - prim.rect.xy) / prim.rect.zw;
    vLayerPos.xy = local_pos.xy;

    vBlendInfo = layer.blend_info;

    gl_Position = uTransform * pos;

    vs(cmd, local_pos);
}

#endif

//======================================================================================
// FS only functions
//======================================================================================
#ifdef WR_FRAGMENT_SHADER

void write_result(vec4 color) {
    oFragColor = vec4(color.rgb, color.a * vBlendInfo.x);
}

float do_clip(vec4 clip_info) {
    vec2 ref_pos = clip_info.xy;
    float alpha = 1.0;
    float d = distance(ref_pos, vLayerPos.xy);
    if (d > abs(clip_info.z) || d < abs(clip_info.w)) {
        alpha = 0.0;
    }
    return alpha;

    /*
    vec2 ref_pos = step(vec2(0, 0), sign(clip_info.xy));
    float alpha = 1.0;
    float d = distance(ref_pos, vLayerPos.xy);
    if (d > abs(clip_info.x) || d < abs(clip_info.z)) {
        alpha = 0.0;
    }
    return alpha;
    */
}

/*
vec4 fetch_initial_color() {
    return vec4(0,0,0,0);
    //return uInitialColor;
}
*/

/*
bool point_in_rect(vec2 p, vec2 p0, vec2 p1) {
    return p.x >= p0.x &&
           p.y >= p0.y &&
           p.x <= p1.x &&
           p.y <= p1.y;
}

void do_border_clip(vec2 pos, vec4 clip_params) {
    float d = distance(pos, abs(clip_params.xy));
    bool is_outside = all(lessThan(pos * sign(clip_params.xy), clip_params.xy)) &&
                      (d > clip_params.z || d < clip_params.w);
    if (is_outside) {
        discard;
    }
}

void do_clip_in(vec2 pos, vec4 clip_rect) {
    if (point_in_rect(pos, clip_rect.xy, clip_rect.zw)) {
        discard;
    }
}

void do_clip(vec2 pos, vec4 clip_rect, vec4 clip_params) {
    vec2 ref_tl = clip_rect.xy + vec2(clip_params.x, clip_params.x);
    vec2 ref_tr = clip_rect.zy + vec2(-clip_params.y, clip_params.y);
    vec2 ref_bl = clip_rect.xw + vec2(clip_params.z, -clip_params.z);
    vec2 ref_br = clip_rect.zw + vec2(-clip_params.w, -clip_params.w);

    float d_tl = distance(pos, ref_tl);
    float d_tr = distance(pos, ref_tr);
    float d_bl = distance(pos, ref_bl);
    float d_br = distance(pos, ref_br);

    bool out0 = pos.x < ref_tl.x && pos.y < ref_tl.y && d_tl > clip_params.x;
    bool out1 = pos.x > ref_tr.x && pos.y < ref_tr.y && d_tr > clip_params.y;
    bool out2 = pos.x < ref_bl.x && pos.y > ref_bl.y && d_bl > clip_params.z;
    bool out3 = pos.x > ref_br.x && pos.y > ref_br.y && d_br > clip_params.w;

    if (out0 || out1 || out2 || out3) {
        discard;
    }
}
*/

vec4 handle_prim(vec4 info,
                 vec4 color,
                 vec4 uv) {
    uint kind = uint(info.x);
    vec4 result = vec4(0, 0, 0, 0);

    switch (kind) {
        case PRIM_KIND_RECT: {
            result = color;
            break;
        }
        case PRIM_KIND_TEXT: {
            result = vec4(color.rgb, color.a * texture(sMask, uv.xy).a);
            break;
        }
        case PRIM_KIND_IMAGE: {
            result = color * texture(sDiffuse, uv.xy);
            break;
        }
        case PRIM_KIND_BORDER_CORNER: {
            float d = info.z - info.w;
            result = mix(color, uv, step(0.0, d));
            break;
        }
    }

    return result;
}

/*
    ALL:
        float (kind)

    clip:
        vec2 (pos)
        float (outer radius)
        float (inner radius)

    rect:
        vec4 (color)
            interp if using gradient, flat otherwise

    text:
        vec4 (color)
        vec2 (uv)

    image:
        vec4 (color)
        vec2 (uv)

    border corner:
        vec4 (color0)
        vec4 (color1)
        vec2 (f)

    rect: 5 (9)
    text: 7 (11)
    image: 7 (11)
    bc: 11 (15)

    POSSIBLE:
        misc: 1 (encode all kinds in one word)
        clip: 4 (ellipse but no inner)
        rect: 1
        gradient: 2 (but what about angle gradients?)
        text: 3
        image: 3
        bc: 4

 */

#endif
