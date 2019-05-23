#version 330 core
//out vec4 FragColor;

layout (location = 0) out vec3 gPosition;
layout (location = 1) out vec3 gNormal;
layout (location = 2) out vec3 gAlbedo;

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

uniform bool hasDisplacement;

vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir);

const float NEAR = 0.1; //近平面
const float FAR = 100.0f;    //投影矩阵的远平面

float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.0; //回到NDC
    return (2.0 * NEAR * FAR) / (FAR + NEAR - z * (FAR - NEAR));
}

void main()
{
    //vec2 texCoords = fs_in.TexCoords;
    //vec4 color = texture(texture_diffuse1, texCoords).rgba;
    //vec3 specular = texture(texture_specular1, texCoords).rgb;
    
    //Position
    gPosition = fs_in.FragPos;
    
    //gNormal
    gNormal = normalize(fs_in.Normal);
    
    //color
    gAlbedo = vec3(0.95);
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
