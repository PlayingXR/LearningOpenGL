#version 330 core           //指定GLSL版本为3.3，匹配OpenGL的版本
layout (location = 0) in vec3 aPos;             //顶点，属性位置为：0
layout (location = 1) in vec3 aNormal;          //法线，属性位置为：1
layout (location = 2) in vec2 aTexCoords;       //UV，属性位置为：2

layout (std140) uniform Matrices
{
    uniform mat4 view;          //视图（观察）矩阵
    uniform mat4 projection;    //投影矩阵
};

uniform mat4 model;


void main()
{

    gl_Position = projection * view * model * vec4(aPos, 1.0);
}
