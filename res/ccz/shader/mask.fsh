#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D u_mask_texture;

void main() {
	vec4 mask_FragColor = texture2D(u_mask_texture, v_texCoord);
    gl_FragColor = v_fragmentColor*texture2D(CC_Texture0, v_texCoord);
    if (mask_FragColor.r > 0.0)
        gl_FragColor.a = 0.0;
}