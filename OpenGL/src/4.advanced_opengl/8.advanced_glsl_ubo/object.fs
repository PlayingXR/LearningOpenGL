#version 330 core
out vec4 FragColor;

in VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
} fs_in;

uniform samplerCube skybox;
uniform vec3 viewPos;

void main()
{
    vec3 norm = normalize(fs_in.Normal);
    vec3 viewDir = normalize(fs_in.FragPos - viewPos);

    //反射
    vec3 R = reflect(viewDir, norm);
    vec3 reflectColor = texture(skybox, R).rgb;
    //折射
    float ratio = 1.0 / 1.33; //水的折射率
    vec3 refra = refract(viewDir, norm, ratio);
    vec3 refractColor = texture(skybox, refra).rgb;

    FragColor = vec4(refractColor, 1.0);
}
