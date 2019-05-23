#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D gBufferInput;

//const vec2 noiseScale = vec2(1600.0/4.0, 1200.0/4.0);

void main()
{
    vec3 color = texture(gBufferInput, TexCoords).rgb;
    FragColor = vec4(color, 1.0);
}
