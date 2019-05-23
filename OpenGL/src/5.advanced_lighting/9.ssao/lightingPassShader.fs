#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D gPosition;
uniform sampler2D gNormal;
uniform sampler2D gAlbedo;
uniform sampler2D ssao;

uniform bool hasSSAO;

struct Light {
    vec3 Position;
    vec3 Color;
    
    float Linear;
    float Quadratic;
    float Radius;
};

uniform Light light;

void main()
{
    const float gamma = 2.2;
    
    vec3 fragPos = texture(gPosition, TexCoords).rgb;
    vec3 normal = texture(gNormal, TexCoords).rgb;
    vec3 albedo = texture(gAlbedo, TexCoords).rgb;
    
    float occlusion = 1.0;
    if (hasSSAO) {
        occlusion = texture(ssao, TexCoords).r;
    }
    
    vec3 ambient = vec3(0.8 * albedo * occlusion);
    
    vec3 lighting = ambient;
    vec3 viewDir = normalize(-fragPos);
    
    //diffuse
    vec3 lightDir = normalize(light.Position - fragPos);
    vec3 diffuse = max(dot(normal, lightDir), 0.0) * albedo * light.Color;
    
    vec3 halfWayDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(normal, halfWayDir), 0.0), 8.0);
    vec3 specular = light.Color * spec;
    
    //        float linear = 0.09;
    //        float quadratic = 0.032;
    float dis = length(light.Position - fragPos);
    float attenuation = 1.0 / (1.0 + light.Linear * dis + light.Quadratic * dis * dis);
    
    diffuse *= attenuation;
    specular *= attenuation;
    
    lighting += diffuse + specular;

    FragColor = vec4(lighting, 1.0);
}
