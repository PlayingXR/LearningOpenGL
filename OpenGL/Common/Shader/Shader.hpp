//
//  Shader.hpp
//  OpenGL
//
//  Created by wxh on 2018/12/25.
//  Copyright © 2018 wxh. All rights reserved.
//

#ifndef Shader_hpp
#define Shader_hpp

#include <glad/glad.h>

#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

#include <glm/glm.hpp>

typedef enum {
    ShaderTypeVertex            = 0x00,     //定点着色器
    ShaderTypeGeometry          = 0x01,     //几何着色器
    ShaderTypeFragment          = 0x02,     //着色器片段
    ShaderTypeProgram           = 0x03,     //着色器程序
}ShaderType;

class Shader
{
private:
    /* 着色器程序 ID */
    GLuint _programID;
    
    /**
     创建着色器

     @param shaderCode GLSL 源代码
     @param type 着色器类型，参见‘ShaderType’
     @return 成功：返回着色器引用ID，失败：返回0
     */
    GLuint createShader(const GLchar* shaderCode, ShaderType type) const;
    
    /**
     创建着色器程序

     @param vShaderID 顶点着色器引用ID
     @param fShaderID 片段着色器引用ID
     @return 成功：返回着色器程序引用ID，失败：返回0
     */
    GLuint createProgram(GLuint vShaderID, GLuint fShaderID) const;
    
    /**
     创建着色器程序

     @param vShaderID 顶点着色器引用ID
     @param gShaderID 几何着色器引用ID
     @param fShaderID 片段着色器引用ID
     @return 成功：返回着色器程序引用ID，失败：返回0
     */
    GLuint createProgram(GLuint vShaderID, GLuint gShaderID, GLuint fShaderID) const;
    
    /**
     获取 uniform 变量地址

     @param name uniform变量key
     @return uniform变量地址
     */
    GLint uniformLocation(const std::string &name) const;
    
    /**
     获取 uniform-block变量索引

     @param name uniform-block变量key
     @return uniform-block索引
     */
    GLuint uniformBlockIndex(const std::string &name) const;
    
    /**
     移除着色器

     @param shaderID 着色器引用ID
     @param type 着色器类型，参见‘ShaderType’
     */
    void removeShader(GLuint shaderID, ShaderType type) const;

    /**
     检查着色器是否出错

     @param shaderID 着色器引用ID
     @param type 着色器类型，参见‘ShaderType’
     @return 成功：返回true，失败：返回false
     */
    bool checkShaderError(GLuint shaderID, ShaderType type) const;
    
public:
    
    /**
     构造函数

     @param vertexPath 顶点Shader的路径
     @param fragmentPath 片段Shader的路径
     */
    Shader(const GLchar* vertexPath, const GLchar* fragmentPath);
    
    /**
     构造函数

     @param vertexPath 顶点Shader的路径
     @param geometryPath 几何Shader的路径
     @param fragmentPath 片段Shader的路径
     */
    Shader(const GLchar* vertexPath, const GLchar* geometryPath, const GLchar *fragmentPath);
    
    ~Shader();
    
    /**
     获取着色器程序引用ID

     @return 着色器程序引用ID
     */
    GLuint programID();
    /**
     使用着色器
     */
    void use() const;
    
    /* 设置 uniform 的值 */
    void setBool(const std::string &name, GLboolean value) const;
    void setInt(const std::string &name, GLint value) const;
    void setFloat(const std::string &name, GLfloat value) const;
    
    void setVec2f(const std::string &name, glm::vec2 &value) const;
    void setVec2f(const std::string &name, GLfloat x, GLfloat y) const;
    
    void setVec3f(const std::string &name, glm::vec3 &value) const;
    void setVec3f(const std::string &name, GLfloat x, GLfloat y, GLfloat z) const;
    
    void setVec4f(const std::string &name, glm::vec4 &value) const;
    void setVec4f(const std::string &name, GLfloat x, GLfloat y, GLfloat z, GLfloat w) const;
    
    void setMat2fv(const std::string &name, glm::mat2 &value) const;
    void setMat2fv(const std::string &name, GLfloat *value) const;
    
    void setMat3fv(const std::string &name, glm::mat3 &value) const;
    void setMat3fv(const std::string &name, GLfloat *value) const;
    
    void setMat4fv(const std::string &name, glm::mat4 &value) const;
    void setMat4fv(const std::string &name, GLfloat *value) const;
    
    /**
     绑定 Uniform-Block 到指定的绑定点

     @param name uniform-block 变量key
     @param bindingPoint 绑定点：1,2,3...,n
     */
    void setBlockBindingPoint(const std::string &name, GLuint bindingPoint);
};
#endif /* Shader_hpp */
