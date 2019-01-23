//
//  Shader.hpp
//  OpenGL
//
//  Created by wxh on 2018/12/25.
//  Copyright © 2018 wxh. All rights reserved.
//

#ifndef Shader_hpp
#define Shader_hpp

#include <stdio.h>
#include <glad/glad.h>

#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

#include "glm/gtc/type_ptr.hpp"

class Shader
{
public:
    //程序ID
    unsigned int ID;
    
    Shader(const GLchar *vertexPath, const GLchar *fragmentPath);
    
    void use();
    
    void setBool(const std::string &name, bool value) const;
    void setInt(const std::string &name, int value) const;
    void setFloat(const std::string &name, float value) const;
    void setVec3f(const std::string &name, float value[]) const;
    void setMat4fv(const std::string &name, GLfloat *value) const;
    ~Shader();
};
#endif /* Shader_hpp */
