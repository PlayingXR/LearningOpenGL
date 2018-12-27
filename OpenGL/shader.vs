#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

out vec3 ourColor;
uniform vec3 center;
uniform float offset;

void main()
{
//    vec3 p = vec3(aPos.x, 2 * center.y - aPos.y, 0.0);//Y轴上下翻转
    vec3 p = aPos;
    p.x += offset;
    gl_Position = vec4(p, 1.0);
    ourColor = p;
}
