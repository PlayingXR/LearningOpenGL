#version 330 core
out vec4 FragColor;

struct Material {
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
};

uniform float shininess;

uniform sampler2D texture_diffuse1;
uniform sampler2D texture_specular1;
uniform sampler2D texture_normal1;
uniform sampler2D texture_height1;
uniform sampler2D texture_depth;

struct Spotlight {
    vec3 position;
    vec3 direction;
    
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    
    float constant;
    float linear;
    float quadratic;
    
    float cutOff;
    float outerCutOff;
};

struct DirectionLight {
    vec3 direction;
    
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

struct PointLight {
    vec3 position;
    
    float constant;
    float linear;
    float quadratic;
    
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

in VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
    vec4 FragPosLightSpace; //输出，在灯光坐标系中的位置
} fs_in;


uniform vec3 viewPos;
uniform vec3 lightPos;
uniform bool blinn;

#define NR_POINT_LIGHTS 4
uniform PointLight pointLights[NR_POINT_LIGHTS];
uniform DirectionLight directionLight;
uniform Spotlight spotlight;

vec3 CalcDirectionLight(DirectionLight light, vec3 normal, vec3 viewDir);
vec3 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir);
vec3 CalcSpotlight(Spotlight light, vec3 mormal, vec3 fragPos, vec3 viewDir);
float ShadowCalculation(vec4 fragPosLightSpace);

void main()
{
    vec3 norm = normalize(fs_in.Normal);
    vec3 viewDir = normalize(viewPos - fs_in.FragPos);
    vec3 lightDir = normalize(lightPos - fs_in.FragPos);
    
    //direction light
//    vec3 result = CalcDirectionLight(directionLight, norm, viewDir);
//
//    //point light
//    for (int i = 0; i < NR_POINT_LIGHTS; i++) {
//        result += CalcPointLight(pointLights[i], norm, fs_in.FragPos, viewDir);
//    }
    
    //spot light
//   result += CalcSpotlight(spotlight, norm, fs_in.FragPos, viewDir);
    
    float gamma = 2.0;
    
    vec3 texColor = vec3(texture(texture_diffuse1, fs_in.TexCoords));
    texColor = pow(texColor, vec3(gamma));
    vec3 lightColor = vec3(1.0);

    float diff = max(dot(norm, lightDir), 0.0);
    
    vec3 halfwayDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(norm, halfwayDir), 0.0), 64.0);

    vec3 ambient = 0.05 * texColor;
    vec3 diffuse =  diff * texColor;
    vec3 specular = spec * lightColor;
//    vec3 result = ambient + diffuse + specular;
    //计算阴影
    float shadow = ShadowCalculation(fs_in.FragPosLightSpace);
    vec3 result = (ambient + (1.0 - shadow) * (diffuse + specular)) * texColor;
    
    //衰减
//    float distance1 = length(lightPos - fs_in.FragPos);
//    float attenuation = 1.0 / distance1;
//    if (blinn) {
//        attenuation = 1.0 / (distance1 * distance1);
//    }
//    result *= attenuation;
    
    result = pow(result, vec3(1.0/gamma));
    FragColor = vec4(result, 1.0);
}

float ShadowCalculation(vec4 fragPosLightSpace)
{
    vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
    projCoords = projCoords * 0.5 + 0.5;
    
    if (projCoords.z > 1.0) {
        return 0.0;
    }
    
    vec3 norm = normalize(fs_in.Normal);
    vec3 lightDir = normalize(lightPos - fs_in.FragPos);
    float bias = max(0.05 * (1.0 - dot(norm, lightDir)), 0.005);
    
    float currentDepth = projCoords.z;
    float shadow = 0.0;
    vec2 texelSize = 1.0 / textureSize(texture_depth, 0);
    for (int x = -1; x <= 1; ++x) {
        for (int y = -1; y <= 1; ++y) {
            float pcfDepth = texture(texture_depth, projCoords.xy + vec2(x, y) * texelSize).r;
            shadow += currentDepth - bias > pcfDepth ? 1.0 : 0.0;
        }
    }
    shadow /= 9.0;
    
//    float closestDepth = texture(texture_depth, projCoords.xy).r;
//    float shadow = currentDepth - bias > closestDepth ? 1.0 : 0.0;
    return shadow;
}

//calculate direction light
vec3 CalcDirectionLight(DirectionLight light, vec3 normal, vec3 viewDir) {
    vec3 lightDir = normalize(-light.direction);
    
    //diffuse
    float diff = max(dot(normal, lightDir), 0.0);
    //specular
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    
    //combine
    vec3 ambient = light.ambient * vec3(texture(texture_diffuse1, fs_in.TexCoords));
    vec3 diffuse = light.diffuse * diff * vec3(texture(texture_diffuse1, fs_in.TexCoords));
    vec3 specular = light.specular * spec * vec3(texture(texture_specular1, fs_in.TexCoords));

    return (ambient + diffuse + specular);
}

//calculate spot light
vec3 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos,vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - fragPos);
    
    //diffuse
    float diff = max(dot(normal, lightDir), 0.0);
    
    //specular
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    
    //attenuation
    float distance = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));
    
    //combine
    vec3 ambient = light.ambient * vec3(texture(texture_diffuse1, fs_in.TexCoords));
    vec3 diffuse = light.diffuse * diff * vec3(texture(texture_diffuse1, fs_in.TexCoords));
    vec3 specular = light.specular * spec * vec3(texture(texture_specular1, fs_in.TexCoords));
    
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
    return (ambient + diffuse + specular);
}

//calculate spot light
vec3 CalcSpotlight(Spotlight light, vec3 normal, vec3 fragPos, vec3 viewDir) {
    vec3 lightDir = normalize(light.position - fragPos);
    
    //diffuse
    float diff = max(dot(normal, lightDir), 0.0);
    //specular
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    
    //attenuation
    float distance = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));
    //spotlight intensity
    float theta = dot(lightDir, normalize(-light.direction));
    float epsilon = light.cutOff - light.outerCutOff;
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);
    
    vec3 ambient = light.ambient * vec3(texture(texture_diffuse1, fs_in.TexCoords));
    vec3 diffuse = light.diffuse * diff * vec3(texture(texture_diffuse1, fs_in.TexCoords));
    vec3 specular = light.specular * spec;// * vec3(texture(texture_specular1, fs_in.TexCoords));
    
    ambient *= attenuation * intensity;
    diffuse *= attenuation * intensity;
    specular *= attenuation * intensity;
    return (ambient + diffuse + specular);
}
