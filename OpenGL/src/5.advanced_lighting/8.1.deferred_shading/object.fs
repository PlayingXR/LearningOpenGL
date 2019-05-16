#version 330 core
out vec4 FragColor;

in VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
} fs_in;

uniform sampler2D texture_diffuse1;
uniform sampler2D texture_specular1;
uniform sampler2D texture_normal1;
uniform sampler2D texture_height1;

uniform sampler2D texture_face;
//uniform samplerCube skybox;
//uniform vec3 viewPos;
//
//in vec3 fColor;

void main()
{
    vec3 color = texture(texture_diffuse1, fs_in.TexCoords).rgb;
//    FragColor = vec4(color, 1.0);
    
    vec3 lightPos = vec3(0.0, 0.0, -1.0);
    vec3 norm = normalize(fs_in.Normal);
    vec3 albedo = vec3(1.0, 1.0, 0.0);
    
    vec3 lightDir = normalize(lightPos - fs_in.FragPos);
    vec3 diffuse = max(dot(norm, lightDir), 0.0) * albedo;
    
//    vec3 norm = normalize(fs_in.Normal);
//    vec3 viewDir = normalize(fs_in.FragPos - viewPos);
//
//    //反射
//    vec3 R = reflect(viewDir, norm);
//    vec3 reflectColor = texture(skybox, R).rgb;
//    //折射
//    float ratio = 1.0 / 1.33; //水的折射率
//    vec3 refra = refract(viewDir, norm, ratio);
//    vec3 refractColor = texture(skybox, refra).rgb;
//
    FragColor = vec4(color, 1.0);
}
