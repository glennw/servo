/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

void main(void)
{
    vColorTexCoord = aColorTexCoordRectTop.xy;
    vec2 local_pos = aPosition.xy;
    gl_Position = uTransform * vec4(local_pos, 0.0, 1.0);
}

