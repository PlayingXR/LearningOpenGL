//
//  PointLight.cpp
//  OpenGL
//
//  Created by wxh on 2019/2/25.
//  Copyright © 2019 wxh. All rights reserved.
//

#include "PointLight.hpp"
PointLight::PointLight(Shader &shader, const std::string &pointLight) : _shader(shader), _pointLight(pointLight)
{
    
}
PointLight::~PointLight()
{
    
}

//设置光源位置
void PointLight::setPosition(glm::vec3 pos)
{
    _shader.setVec3f(_pointLight + "." + _position, pos);
}
void PointLight::setPosition(GLfloat posX, GLfloat posY, GLfloat posZ)
{
    _shader.setVec3f(_pointLight + "." + _position, posX, posY, posZ);
}

//设置光强度衰减公式：常数项
void PointLight::setConstant(GLfloat constant)
{
    _shader.setFloat(_pointLight + "." + _constant, constant);
}

//设置光强度衰减公式：一次项
void PointLight::setLinear(GLfloat linear)
{
    _shader.setFloat(_pointLight + "." + _linear, linear);
}

//设置光强度衰减公式：二次项
void PointLight::setQuadratic(GLfloat quadratic)
{
    _shader.setFloat(_pointLight + "." + _quadratic, quadratic);
}

//设置环境光照强度
void PointLight::setAmbient(glm::vec3 ambient)
{
    _shader.setVec3f(_pointLight + "." + _ambient, ambient);
}
void PointLight::setAmbient(GLfloat ambientR, GLfloat ambientG, GLfloat ambientB)
{
    _shader.setVec3f(_pointLight + "." + _ambient, ambientR, ambientG, ambientB);
}

//设置漫反射光照强度
void PointLight::setDiffuse(glm::vec3 diffuse)
{
    _shader.setVec3f(_pointLight + "." + _diffuse, diffuse);
}
void PointLight::setDiffuse(GLfloat diffuseR, GLfloat diffuseG, GLfloat diffuseB)
{
    _shader.setVec3f(_pointLight + "." + _diffuse, diffuseR, diffuseG, diffuseB);
}

//设置镜面反射光照强度
void PointLight::setSpecular(glm::vec3 specular)
{
    _shader.setVec3f(_pointLight + "." + _specular, specular);
}
void PointLight::setSpecular(GLfloat specularR, GLfloat specularG, GLfloat specularB)
{
    _shader.setVec3f(_pointLight + "." + _specular, specularR, specularG, specularB);
}
