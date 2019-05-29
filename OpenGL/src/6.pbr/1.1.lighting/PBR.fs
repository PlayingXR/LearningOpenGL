#version 330 core
out vec4 FragColor;

uniform sampler2D texture_diffuse1;
uniform sampler2D texture_specular1;
uniform sampler2D texture_normal1;
uniform sampler2D texture_height1;
uniform sampler2D diffuseMap;
uniform sampler2D normalMap;
uniform sampler2D depthMap;

//meterial parameters
uniform vec3 albedo;
uniform float metallic;
uniform float roughness;
uniform float ao;

//lights
const int lightCount = 4;
uniform vec3 lightPositions[lightCount];
uniform vec3 lightColors[lightCount];

uniform vec3 camPos;

const float PI = 3.14159265359;

in VS_OUT
{
    vec2 TexCoords;         //输出，UV
    vec3 Normal;            //输出，法线
    vec3 FragPos;           //输出，片段位置
    
    vec3 TangentFragPos;
    vec3 TangentViewPos;
    vec3 TangentLightPos;
} fs_in;

//Trowbridge-Reita GGX正态分布函数
//N: 法线
//H：入射光线与观察点的中间向量
//roughness：表面粗糙度
float DistributionGGX(vec3 N, vec3 H, float roughness)
{
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH * NdotH;
    
    float nom = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;
    return nom / max(denom, 0.001); //防止roughness = 0.0， NdotH = 1.0，分母为0的情况
}

float GeometrySchlickGGX(float NdotV, float roughness)
{
    //直接光照
    float r = (roughness + 1.0);
    float k = (r * r) / 8.0;
    
    //IBL
//    float k = roughness * roughness / 2.0;
    float nom = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    
    return nom / denom;
}

//几何函数
float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
    float k = roughness;
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx1 = GeometrySchlickGGX(NdotV, k);
    float ggx2 = GeometrySchlickGGX(NdotL, k);
    
    return ggx1 * ggx2;
}

//菲涅尔方程，返回的是一个物体表面光线被反射的百分比，反射率
vec3 fresnelSchlick(float HdotV, vec3 F0)
{
    float cosTheta = HdotV;
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}


void main()
{
    vec3 WorldPos = fs_in.FragPos;
    vec3 N = normalize(fs_in.Normal);
    vec3 V = normalize(camPos - WorldPos);  //观察方向，从点到Camera的向量
    
    //计算反射率
    vec3 F0 = vec3(0.04);   //基础反射率，不同材质会不一样
    F0 = mix(F0, albedo, metallic);
    
    vec3 Lo = vec3(0.0);
    for (int i = 0; i < 1; ++i)
    {
        vec3 lightPosition = lightPositions[i];
        vec3 lightColor = lightColors[i];
        
        vec3 L = normalize(lightPosition - WorldPos);   //灯光方向，从点到光源的向量
        vec3 H = normalize(V + L);  //观察方向与灯光方向的中间向量
        float HdotV = clamp(dot(H, V), 0.0, 1.0);
        float NdotV = max(dot(N, V), 0.0);
        float NdotL = max(dot(N, L), 0.0);
        
        //计算辐射率（radiance）
        float dis = length(lightPosition - WorldPos);
        float attenuation = 1.0 / (dis * dis);  //衰减
        vec3 radiance = lightColor * attenuation;
        
        //Cook-Torrance BRDF
        
        //计算高光部分 Ks * Fcook-torrance，
        float NDF = DistributionGGX(N, H, roughness);
        float G = GeometrySmith(N, V, L, roughness);
        vec3 F = fresnelSchlick(HdotV, F0);

        vec3 nominator = NDF * G * F;
        float denominator = 4 * NdotV * NdotL;
        vec3 specular = nominator / max(denominator, 0.001);
        
        vec3 kS = F;    //Ks：高光反射率，可以使用菲涅尔方程计算
        vec3 kD = vec3(1.0) - kS;   //根据能量守恒，漫反射率 = 1.0 - 高光反射率
        kD *= 1.0 - metallic;
        
//        Lo += (kD * albedo / PI + specular) * radiance * NdotL;
//        Lo += specular * radiance * NdotL;
        Lo = specular;
    }
    
    vec3 ambient = vec3(0.03) * albedo * ao;
    
    vec3 color = ambient + Lo;
    
    // HDR to LDR
    color = color / (color + vec3(1.0));
    
    //gamma correct
    color = pow(color, vec3(1.0 / 2.2));
    
    FragColor = vec4(color, 1.0);
}
