#version 330 core
struct Material {
    sampler2D diffuse;
    sampler2D specular;
    sampler2D emission;
    float shininess;
};
struct Light {
//    vec3 position;
    vec3 direction;
    
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform Material material;
uniform Light light;

out vec4 FragColor;

in vec2 TexCoords;
in vec3 Normal;
in vec3 FragPos;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float mixValue;

uniform vec3 viewPos;


void main()
{
//    FragColor = mix(texture(texture1, texCoord), texture(texture2, vec2(texCoord.x, texCoord.y)), mixValue);
    vec3 lightDir = normalize(-light.direction);
    
    //ambient
    vec3 ambient = light.ambient * vec3(texture(material.diffuse, TexCoords));
    
    //diffuse
    vec3 norm = normalize(Normal);
//    vec3 lightDir = normalize(light.position - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * (diff * vec3(texture(material.diffuse, TexCoords)));
    
    //specular
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    
    vec3 specularMap = vec3(texture(material.specular, TexCoords));
    vec3 specular = light.specular * (spec * specularMap);
    
    //emission
    vec3 emission = vec3(texture(material.emission, TexCoords));
    
    vec3 result = ambient + diffuse + specular ;
    FragColor = vec4(result, 1.0);
}
