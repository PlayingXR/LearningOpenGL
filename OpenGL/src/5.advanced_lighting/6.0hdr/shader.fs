#version 330 core
out vec4 FragColor;

uniform sampler2D texture_diffuse1;
uniform sampler2D texture_specular1;
uniform sampler2D texture_normal1;
uniform sampler2D texture_height1;
uniform sampler2D diffuseMap;
uniform sampler2D normalMap;
uniform sampler2D depthMap;

uniform float Shininess;
uniform float heightScale;

in VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
    
    vec3 TangentFragPos;
    vec3 TangentViewPos;
    vec3 TangentLightPos;
} fs_in;

struct Light {
    vec3 Position;
    vec3 Color;
};

uniform bool hasDisplacement;

vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir);

uniform vec3 viewPos;

uniform Light lights[16];

void main()
{
    vec2 texCoords = fs_in.TexCoords;
    
    vec3 color = texture(diffuseMap, texCoords).rgb;
    
    vec3 normal = normalize(fs_in.Normal);
    
    vec3 ambient = 0.0 * color;
    vec3 lighting = vec3(0.0);
    
    vec3 fragPosition = fs_in.FragPos;
    
    for (int i = 0; i < 16; i++) {
        
        vec3 lightPosition = lights[i].Position;
        
        //diffuse
        vec3 lightDir = normalize(lightPosition - fragPosition);
        float diff = max(dot(lightDir, normal), 0.0);
        vec3 diffuse = lights[i].Color * diff * color;
        
        vec3 result = diffuse;
        
        float dis = length(fragPosition - lightPosition);
        result *= 1.0 / ( dis * dis);
        lighting += result;
    }

    FragColor = vec4(lighting, 1.0);
}
//vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir)
//{
//    float height = texture(depthMap, texCoords).r;
//    vec2 p = viewDir.xy * (height * heightScale);
//    return texCoords - p;
//}

//vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir)
//{
//    const float minLayers = 8;
//    const float maxLayers = 32;
//
//    float numLayers = mix(maxLayers, minLayers, abs(dot(vec3(0.0, 0.0, 1.0), viewDir)));
////    numLayers = 10;
//    float layerDepth = 1.0 / numLayers;
//    float currentLayerDepth = 0.0;
//
//    vec2 p = viewDir.xy * heightScale;
//    vec2 deltaTexCoords = p / numLayers;
//
//    vec2 currentTexCoords = texCoords;
//    float currentDepthMapValue = texture(depthMap, currentTexCoords).r;
//
//    while(currentLayerDepth < currentDepthMapValue) {
//        currentTexCoords -= deltaTexCoords;
//        currentDepthMapValue = texture(depthMap, currentTexCoords).r;
//        currentLayerDepth += layerDepth;
//    }
//
//    return currentTexCoords;
//}

vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir)
{
    const float minLayers = 8;
    const float maxLayers = 32;
    float numLayers = mix(maxLayers, minLayers, abs(dot(vec3(0.0, 0.0, 1.0), viewDir)));

    float layerDepth = 1.0 / numLayers;

    float currentLayerDepth = 0.0;

    vec2 P = viewDir.xy / viewDir.z * heightScale;
    vec2 deltaTexCoords = P / numLayers;

    vec2  currentTexCoords     = texCoords;
    float currentDepthMapValue = texture(depthMap, currentTexCoords).r;

    while(currentLayerDepth < currentDepthMapValue)
    {
        currentTexCoords -= deltaTexCoords;
        currentDepthMapValue = texture(depthMap, currentTexCoords).r;
        currentLayerDepth += layerDepth;
    }
    
    //遮蔽计算
    vec2 prevTexCoords = currentTexCoords + deltaTexCoords;
    
    float afterDepth = currentDepthMapValue - currentLayerDepth;
    float beforeDepth = texture(depthMap, prevTexCoords).r - currentLayerDepth + layerDepth;
    
    float weight = afterDepth / (afterDepth - beforeDepth);
    vec2 finalTexCoords = prevTexCoords * weight + currentTexCoords * (1.0 - weight);
    return finalTexCoords;
}
