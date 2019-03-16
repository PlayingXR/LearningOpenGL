#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D depthMap;
uniform float near_Plane;
uniform float far_Plane;

float LinearizeDepth(float depth)
{
    //把0～1转换到-1～1
    float z = depth * 2.0 - 1.0;
    return (2.0 * near_Plane * far_Plane) / (far_Plane + near_Plane - z * (far_Plane - near_Plane));
}
void main()
{
    float depthValue = texture(depthMap, TexCoords).r;
//    FragColor = vec4(vec3(LinearizeDepth(depthValue) / far_Plane), 1.0);    //perspective
    FragColor = vec4(vec3(depthValue), 1.0);
}
