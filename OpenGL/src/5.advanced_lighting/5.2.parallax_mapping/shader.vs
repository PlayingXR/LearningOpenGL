#version 330 core           //指定GLSL版本为3.3，匹配OpenGL的版本
layout (location = 0) in vec3 aPos;             //顶点，属性位置为：0
layout (location = 1) in vec3 aNormal;          //法线，属性位置为：1
layout (location = 2) in vec2 aTexCoords;       //UV，属性位置为：2
layout (location = 3) in vec3 aTangent;         //切线
layout (location = 4) in vec3 aBitangent;       //副切线

out VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
    
    vec3 TangentFragPos;
    vec3 TangentViewPos;
    vec3 TangentLightPos;
} vs_out;


layout (std140) uniform Matrices
{
    uniform mat4 view;              //视图（观察）矩阵
    uniform mat4 projection;        //投影矩阵
};

uniform mat4 normal;        //法线矩阵，由模型矩阵左上角的逆矩阵的转置矩阵得到，3x3
uniform mat4 model;         //模型矩阵

uniform vec3 lightPos;
uniform vec3 viewPos;


void main()
{
    gl_Position = projection * view * model * vec4(aPos, 1.0);
    
    vs_out.TexCoords = aTexCoords;
    vs_out.Normal = mat3(normal) * aNormal;
    vs_out.FragPos = vec3(model * vec4(aPos, 1.0));
    
    vec3 T = normalize(mat3(normal) * aTangent);
    vec3 N = normalize(mat3(normal) * aNormal);
    T = normalize(T - dot(T, N) * N);
    vec3 B = cross(N, T);
    
    mat3 TBN = transpose(mat3(T, B, N));
    
    vs_out.TangentFragPos = TBN * vs_out.FragPos;
    vs_out.TangentLightPos = TBN * lightPos;
    vs_out.TangentViewPos = TBN * viewPos;
}
