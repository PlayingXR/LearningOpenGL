#version 330 core           //指定GLSL版本为3.3，匹配OpenGL的版本
layout (triangles) in;         //输入点
layout (line_strip, max_vertices = 6) out;      //输出线

in VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
} gs_in[];

out VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
} gs_out;

uniform float time;

//计算出法线
vec3 GetNormal()
{
    vec3 a = vec3(gl_in[0].gl_Position) - vec3(gl_in[1].gl_Position);
    vec3 b = vec3(gl_in[2].gl_Position) - vec3(gl_in[1].gl_Position);
    return normalize(cross(a, b));
}

vec4 explode(vec4 position, vec3 normal)
{
    float magnitude = 2.0;
    vec3 direction = normal * ((sin(time) + 1.0)) * magnitude;
    return position + vec4(direction, 0.0);
}

void exploding()
{
    vec3 normal = GetNormal();
    gs_out.Normal = normal;
    
    gs_out.FragPos = gs_in[0].FragPos;
    gs_out.TexCoords = gs_in[0].TexCoords;
    gl_Position = explode(gl_in[0].gl_Position, normal);
    EmitVertex();
    
    gs_out.FragPos = gs_in[1].FragPos;
    gs_out.TexCoords = gs_in[1].TexCoords;
    gl_Position = explode(gl_in[1].gl_Position, normal);
    EmitVertex();
    
    gs_out.FragPos = gs_in[2].FragPos;
    gs_out.TexCoords = gs_in[2].TexCoords;
    gl_Position = explode(gl_in[2].gl_Position, normal);
    EmitVertex();
    EndPrimitive();
}

const float MAGNITUDE = 0.1;

void GenerateLine(int index)
{
    gs_out.Normal = gs_in[index].Normal;
    gs_out.FragPos = gs_in[index].FragPos;
    gs_out.TexCoords = gs_in[index].TexCoords;
    
    gl_Position = gl_in[index].gl_Position;
    EmitVertex();
    
    gl_Position = gl_in[index].gl_Position + vec4(gs_in[index].Normal, 0.0) * MAGNITUDE;
    EmitVertex();
    EndPrimitive();
}

void main()
{
    GenerateLine(0);
    GenerateLine(1);
    GenerateLine(2);
}
