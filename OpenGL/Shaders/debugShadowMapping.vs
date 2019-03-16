#version 330 core
layout (location = 0) in vec3 aPos;             //顶点，属性位置为：0
layout (location = 1) in vec3 aNormal;          //法线，属性位置为：1
layout (location = 2) in vec2 aTexCoords;       //UV，属性位置为：2

out vec2 TexCoords;

void main()
{
    TexCoords = aTexCoords;
    gl_Position = vec4(aPos, 1.0);
}
