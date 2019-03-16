#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;          //法线，属性位置为：1
layout (location = 2) in vec3 aTexCoords;

out vec2 TexCoords;         //输出，UV
out vec3 Normal;            //输出，法线
out vec3 FragPos;           //输出，片段位置

uniform mat4 model;         //模型矩阵
uniform mat4 view;          //视图（观察）矩阵
uniform mat4 projection;    //投影矩阵
uniform mat4 normal;        //法线矩阵，由模型矩阵左上角的逆矩阵的转置矩阵得到，3x3
void main()
{

    gl_Position = projection * view * model * vec4(aPos, 1.0);
    TexCoords = aTexCoords.xy;
    Normal = mat3(normal) * aNormal;
    FragPos = vec3(model * vec4(aPos, 1.0));
}
