//
//  Spotlight.cpp
//  OpenGL
//
//  Created by wxh on 2019/2/25.
//  Copyright © 2019 wxh. All rights reserved.
//

#include "Spotlight.hpp"
Spotlight::Spotlight(Shader &shader, const std::string &spotlight) : _shader(shader), _spotlight(spotlight)
{
    
}
Spotlight::~Spotlight()
{
    
}

//设置光源位置
void Spotlight::setPosition(glm::vec3 pos)
{
    _shader.setVec3f(_spotlight + "." + _position, pos);
}
void Spotlight::setPosition(GLfloat posX, GLfloat posY, GLfloat posZ)
{
    _shader.setVec3f(_spotlight + "." + _position, posX, posY, posZ);
}

//设置光源方向
void Spotlight::setDirection(glm::vec3 direction)
{
    _shader.setVec3f(_spotlight + "." + _direction, direction);
}

//设置内切光角：余弦
void Spotlight::setCutOff(GLfloat cutOff)
{
    _shader.setFloat(_spotlight + "." + _cutOff, cutOff);
}

//设置外切光角：余弦
void Spotlight::setOuterCutOff(GLfloat outerCutOff)
{
    _shader.setFloat(_spotlight + "." + _outerCutOff, outerCutOff);
}

//设置光强度衰减公式：常数项
void Spotlight::setConstant(GLfloat constant)
{
    _shader.setFloat(_spotlight + "." + _constant, constant);
}

//设置光强度衰减公式：一次项
void Spotlight::setLinear(GLfloat linear)
{
    _shader.setFloat(_spotlight + "." + _linear, linear);
}

//设置光强度衰减公式：二次项
void Spotlight::setQuadratic(GLfloat quadratic)
{
    _shader.setFloat(_spotlight + "." + _quadratic, quadratic);
}

//设置环境光照强度
void Spotlight::setAmbient(glm::vec3 ambient)
{
    _shader.setVec3f(_spotlight + "." + _ambient, ambient);
}
void Spotlight::setAmbient(GLfloat ambientR, GLfloat ambientG, GLfloat ambientB)
{
    _shader.setVec3f(_spotlight + "." + _ambient, ambientR, ambientG, ambientB);
}

//设置漫反射光照强度
void Spotlight::setDiffuse(glm::vec3 diffuse)
{
    _shader.setVec3f(_spotlight + "." + _diffuse, diffuse);
}
void Spotlight::setDiffuse(GLfloat diffuseR, GLfloat diffuseG, GLfloat diffuseB)
{
    _shader.setVec3f(_spotlight + "." + _diffuse, diffuseR, diffuseG, diffuseB);
}

//设置镜面反射光照强度
void Spotlight::setSpecular(glm::vec3 specular)
{
    _shader.setVec3f(_spotlight + "." + _specular, specular);
}
void Spotlight::setSpecular(GLfloat specularR, GLfloat specularG, GLfloat specularB)
{
    _shader.setVec3f(_spotlight + "." + _specular, specularR, specularG, specularB);
}
