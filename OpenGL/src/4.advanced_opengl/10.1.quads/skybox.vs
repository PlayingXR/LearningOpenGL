#version 330 core
layout (location = 0) in vec3 aPos;

out vec3 TexCoords;

layout (std140) uniform Matrices
{
    uniform mat4 view;          //视图（观察）矩阵
    uniform mat4 projection;    //投影矩阵
};

void main()
{
    TexCoords = aPos;
    vec4 pos = projection * mat4(mat3(view)) * vec4(aPos, 1.0);
    gl_Position = pos.xyww;
}
