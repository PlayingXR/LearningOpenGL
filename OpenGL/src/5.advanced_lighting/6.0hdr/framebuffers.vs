#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;          //法线，属性位置为：1
layout (location = 2) in vec3 aTexCoords;

out vec2 TexCoords;         //输出，UV

void main()
{
    gl_Position = vec4(aPos.x, aPos.y, 1.0, 1.0);
    TexCoords = aTexCoords.xy;
}
