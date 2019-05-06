#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D screenTexture;

uniform float exposure;

uniform bool hasHDR;

void main()
{
    const float gamma = 2.2;
    
    vec3 hdrColor = texture(screenTexture, TexCoords).rgb;
    
    if (hasHDR) {
//        vec3 mapped = hdrColor / (hdrColor + vec3(1.0));
        vec3 mapped = vec3(1.0) - exp(-hdrColor * exposure);
        
        mapped = pow(mapped, vec3(1.0 / gamma));
        
        FragColor = vec4(mapped, 1.0);
    } else {
        FragColor = vec4(hdrColor, 1.0);
    }

}
