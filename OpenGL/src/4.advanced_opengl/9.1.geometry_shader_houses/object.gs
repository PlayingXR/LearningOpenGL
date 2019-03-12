#version 330 core           //指定GLSL版本为3.3，匹配OpenGL的版本
layout (points) in;         //输入点
layout (triangle_strip, max_vertices = 5) out;      //输出线

in VS_OUT
{
    vec3 color;
} gs_in[];

out vec3 fColor;

void main()
{
    gl_Position = gl_in[0].gl_Position + vec4(-0.2, -0.2, 0.0, 0.0);
    fColor = gs_in[0].color;
    EmitVertex();

    gl_Position = gl_in[0].gl_Position + vec4(0.2, -0.2, 0.0, 0.0);
    EmitVertex();
    
    gl_Position = gl_in[0].gl_Position + vec4(-0.2, 0.2, 0.0, 0.0);
    EmitVertex();
    
    gl_Position = gl_in[0].gl_Position + vec4(0.2, 0.2, 0.0, 0.0);
    EmitVertex();
    
    gl_Position = gl_in[0].gl_Position + vec4(0.0, 0.4, 0.0, 0.0);
    fColor = vec3(1.0);
    EmitVertex();

    EndPrimitive();
}
