#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D gPosition;
uniform sampler2D gNormal;
uniform sampler2D gAlbedoSpec;

struct Light {
    vec3 Position;
    vec3 Color;
};

const int NR_LIGHTS = 32;
uniform Light lights[NR_LIGHTS];
uniform vec3 viewPos;

void main()
{
    const float gamma = 2.2;
    
    vec3 fragPos = texture(gPosition, TexCoords).rgb;
    vec3 normal = texture(gNormal, TexCoords).rgb;
    vec4 albedoSpec = texture(gAlbedoSpec, TexCoords).rgba;
    
    vec3 albedo = albedoSpec.rgb;
    float specular = albedoSpec.a;
    
    vec3 lighting = albedo * 0.1;
    vec3 viewDir = normalize(viewPos - fragPos);
    
    for (int i = 0; i < NR_LIGHTS; ++i) {
        //diffuse
        vec3 lightDir = normalize(lights[i].Position - fragPos);
        vec3 diffuse = max(dot(normal, lightDir), 0.0) * albedo * lights[i].Color;
        
        vec3 halfWayDir = normalize(lightDir + viewDir);
        float spec = pow(max(dot(normal, halfWayDir), 0.0), 16.0);
        vec3 specular = lights[i].Color * spec * specular;
        
        float dis = length(lights[i].Position - fragPos);
        
        float linear = 0.09;
        float quadratic = 0.032;
        float attenuation = 1.0 / (1.0 + linear * dis + quadratic * dis * dis);
        
        diffuse *= attenuation;
        specular *= attenuation;
        
        lighting += diffuse + specular;
    }
    
//    vec3 bloomColor = texture(bloomBlur, TexCoords).rgb;
//
//    if (hasBloom) {
//        hdrColor += bloomColor;
//    }
//
//    vec3 mapped = vec3(1.0) - exp(-hdrColor * exposure);
//    mapped = pow(mapped, vec3(1.0 / gamma));
//    FragColor = vec4(mapped, 1.0);
    
    FragColor = vec4(lighting, 1.0);
}
