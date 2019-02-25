//
//  DirectionLight.cpp
//  OpenGL
//
//  Created by wxh on 2019/2/25.
//  Copyright © 2019 wxh. All rights reserved.
//

#include "DirectionLight.hpp"

DirectionLight::DirectionLight(Shader &shader, const std::string &directionLight) : _shader(shader), _directionLight(directionLight)
{
    
}
DirectionLight::~DirectionLight()
{
    
}

//设置光照方向
void DirectionLight::setDirection(glm::vec3 dir)
{
    _shader.setVec3f(_directionLight + "." + _direction, dir);
}
void DirectionLight::setDirection(GLfloat dirX, GLfloat dirY, GLfloat dirZ)
{
    _shader.setVec3f(_directionLight + "." + _direction, dirX, dirY, dirZ);
}

//设置环境光照强度
void DirectionLight::setAmbient(glm::vec3 ambient)
{
    _shader.setVec3f(_directionLight + "." + _ambient, ambient);
}
void DirectionLight::setAmbient(GLfloat ambientR, GLfloat ambientG, GLfloat ambientB)
{
    _shader.setVec3f(_directionLight + "." + _ambient, ambientR, ambientG, ambientB);
}

//设置漫反射光照强度
void DirectionLight::setDiffuse(glm::vec3 diffuse)
{
    _shader.setVec3f(_directionLight + "." + _diffuse, diffuse);
}
void DirectionLight::setDiffuse(GLfloat diffuseR, GLfloat diffuseG, GLfloat diffuseB)
{
    _shader.setVec3f(_directionLight + "." + _diffuse, diffuseR, diffuseG, diffuseB);
}

//设置镜面反射光照强度
void DirectionLight::setSpecular(glm::vec3 specular)
{
    _shader.setVec3f(_directionLight + "." + _specular, specular);
}
void DirectionLight::setSpecular(GLfloat specularR, GLfloat specularG, GLfloat specularB)
{
    _shader.setVec3f(_directionLight + "." + _specular, specularR, specularG, specularB);
}
