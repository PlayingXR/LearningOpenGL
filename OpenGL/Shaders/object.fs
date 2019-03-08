#version 330 core
out vec4 FragColor;


in vec2 TexCoords;
in vec3 Normal;
in vec3 FragPos;

uniform samplerCube skybox;
uniform vec3 viewPos;

void main()
{
    vec3 norm = normalize(Normal);
    vec3 viewDir = normalize(FragPos - viewPos);
    
    //反射
    vec3 R = reflect(viewDir, norm);
    vec3 reflectColor = texture(skybox, R).rgb;
    //折射
    float ratio = 1.0 / 1.33; //水的折射率
    vec3 refra = refract(viewDir, norm, ratio);
    vec3 refractColor = texture(skybox, refra).rgb;
    

    FragColor = vec4(refractColor, 1.0);
}
