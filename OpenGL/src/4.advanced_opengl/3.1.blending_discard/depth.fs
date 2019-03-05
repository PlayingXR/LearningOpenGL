#version 330 core
out vec4 FragColor;

in vec2 TexCoords;
in vec3 Normal;
in vec3 FragPos;

uniform sampler2D texture_diffuse;

float near = 0.1f;
float far = 100.0f;

float LinearizeDepth(float depth) {
    float z = depth * 2.0 - 1.0;
    return (2.0 * near * far) / (far + near - z * (far - near));
}

void main()
{
    vec4 texColor = texture(texture_diffuse, TexCoords);
    if (texColor.a < 0.1) {
        discard;
    }
    FragColor = texColor;
}
