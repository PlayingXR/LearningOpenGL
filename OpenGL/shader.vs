#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;
layout (location = 2) in vec2 aTexCoord;

out vec3 ourColor;
out vec2 texCoord;

uniform vec3 center;
uniform float offset;

void main()
{
//    vec3 p = vec3(aPos.x, 2 * center.y - aPos.y, 0.0);//Y轴上下翻转
    vec3 p = aPos;
//    p.x += offset;
    gl_Position = vec4(p, 1.0);
    ourColor = aColor;
    texCoord = vec2(aTexCoord.x, aTexCoord.y);
}
