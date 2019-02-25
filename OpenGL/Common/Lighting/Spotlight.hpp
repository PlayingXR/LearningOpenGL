//
//  Spotlight.hpp
//  OpenGL
//
//  Created by wxh on 2019/2/25.
//  Copyright © 2019 wxh. All rights reserved.
//

#ifndef Spotlight_hpp
#define Spotlight_hpp

#include <iostream>
#include <glad/glad.h>
#include <glm/glm.hpp>
#include "Shader.hpp"

/* 聚光光源属性
struct Spotlight {
    vec3 position;      //光源位置
    vec3 direction;     //光源方向向量
    
    float cutOff;       //内切光角：余弦
    float outerCutOff;  //外切光角：余弦
    
    float constant;     //光强度衰减公式：常数项
    float linear;       //光强度衰减公式：一次项
    float quadratic;    //光强度衰减公式：二次项
    
    vec3 ambient;       //环境光照强度
    vec3 diffuse;       //漫反射光照强度
    vec3 specular;      //镜面反射光照强度
};
 */

class Spotlight
{
private:
    Shader _shader;                                         //着色器对象
    const std::string _spotlight;                           //（GLSL）平行光变量
    
    const std::string _position     = "position";           //（GLSL）光源位置变量
    const std::string _direction    = "direction";
    
    const std::string _cutOff       = "cutOff";             //（GLSL）内切光角：余弦 变量
    const std::string _outerCutOff  = "outerCutOff";        //（GLSL）外切光角：余弦 变量
    
    const std::string _constant     = "constant";           //（GLSL）光强度衰减公式：常数项变量
    const std::string _linear       = "linear";             //（GLSL）光强度衰减公式：一次项变量
    const std::string _quadratic    = "quadratic";          //（GLSL）光强度衰减公式：二次项变量
    
    const std::string _ambient      = "ambient";            //（GLSL）环境光照强度变量
    const std::string _diffuse      = "diffuse";            //（GLSL）漫反射光照强度变量
    const std::string _specular     = "specular";           //（GLSL）镜面反射光照强度变量
public:
    Spotlight(Shader &shader, const std::string &spotlight);
    ~Spotlight();
    
    //设置光源位置
    void setPosition(glm::vec3 pos);
    void setPosition(GLfloat posX, GLfloat posY, GLfloat posZ);
    
    //设置光源方向
    void setDirection(glm::vec3 direction);
    
    //设置内切光角：余弦
    void setCutOff(GLfloat cutOff);
    
    //设置外切光角：余弦
    void setOuterCutOff(GLfloat outerCutOff);
    
    //设置光强度衰减公式：常数项
    void setConstant(GLfloat constant);
    
    //设置光强度衰减公式：一次项
    void setLinear(GLfloat linear);
    
    //设置光强度衰减公式：二次项
    void setQuadratic(GLfloat quadratic);
    
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

#endif /* Spotlight_hpp */
