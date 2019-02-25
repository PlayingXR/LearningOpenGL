//
//  DirectionLight.hpp
//  OpenGL
//
//  Created by wxh on 2019/2/25.
//  Copyright © 2019 wxh. All rights reserved.
//

#ifndef DirectionLight_hpp
#define DirectionLight_hpp

#include <iostream>
#include <glad/glad.h>
#include <glm/glm.hpp>

#include "Shader.hpp"

/* 平行光属性
struct DirectionLight {
    vec3 direction;         //光照方向向量
 
    vec3 ambient;           //环境光照强度
    vec3 diffuse;           //漫反射光照强度
    vec3 specular;          //镜面反射光照强度
};
 */

class DirectionLight
{
private:
    Shader _shader;                                             //着色器对象
    const std::string _directionLight;                          //（GLSL）平行光变量
    const std::string _direction        = "direction";          //（GLSL）光照方向变量
    
    const std::string _ambient          = "ambient";            //（GLSL）环境光照强度变量
    const std::string _diffuse          = "diffuse";            //（GLSL）漫反射光照强度变量
    const std::string _specular         = "specular";           //（GLSL）镜面反射光照强度变量
public:
    DirectionLight(Shader &shader, const std::string &directionLight);
    ~DirectionLight();
    
    //设置光照方向
    void setDirection(glm::vec3 dir);
    void setDirection(GLfloat dirX, GLfloat dirY, GLfloat dirZ);
    
    //设置环境光照强度
    void setAmbient(glm::vec3 ambient);
    void setAmbient(GLfloat ambientR, GLfloat ambientG, GLfloat ambientB);
    
    //设置漫反射光照强度
    void setDiffuse(glm::vec3 diffuse);
    void setDiffuse(GLfloat diffuseR, GLfloat diffuseG, GLfloat diffuseB);
    
    //设置镜面反射光照强度
    void setSpecular(glm::vec3 specular);
    void setSpecular(GLfloat specularR, GLfloat specularG, GLfloat specularB);
};
 
 
 

#endif /* DirectionLight_hpp */
