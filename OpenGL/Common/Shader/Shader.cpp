//
//  Shader.cpp
//  OpenGL
//
//  Created by wxh on 2018/12/25.
//  Copyright © 2018 wxh. All rights reserved.
//

#include "Shader.hpp"

#define LOG_BUF_LEN 512     /* log 输出缓冲区长度 */

#pragma mark - Private
GLuint Shader::createShader(const GLchar* shaderCode, ShaderType type) const
{
    if (NULL == shaderCode) {
        std::cout << "无法创建着色器!" << std::endl;
        return 0;
    }
    
    /*声明一个着色器引用ID */
    GLuint shaderID = 0;
    if (type == ShaderTypeVertex) {
        shaderID = glCreateShader(GL_VERTEX_SHADER);
    } else if (type == ShaderTypeGeometry) {
        shaderID = glCreateShader(GL_GEOMETRY_SHADER);
    } else if (type == ShaderTypeFragment) {
        shaderID = glCreateShader(GL_FRAGMENT_SHADER);
    }
    
    /* 创建着色器 GLSL 的源码 */
    glShaderSource(shaderID, 1, &shaderCode, NULL);
    
    /* 编译着色器 */
    glCompileShader(shaderID);
    
    /* 检查着色器编译是否出错 */
    checkShaderError(shaderID, type);
    
    return shaderID;
}
GLuint Shader::createProgram(GLuint vShaderID, GLuint fShaderID) const
{
    if (0 == vShaderID || 0 == fShaderID) {
        std::cout << "无法创建着色器程序" << std::endl;
        return 0;
    }
    
    //声明一个着色器程序对象引用ID
    GLuint programID;
    //创建着色器程序
    programID = glCreateProgram();
    //添加顶点着色器
    glAttachShader(programID, vShaderID);
    //添加片段着色器
    glAttachShader(programID, fShaderID);
    //链接着色器程序
    glLinkProgram(programID);
    //检查着色器链接是否出错
    checkShaderError(programID, ShaderTypeProgram);
    
    return programID;
}
GLuint Shader::createProgram(GLuint vShaderID, GLuint gShaderID, GLuint fShaderID) const
{
    if (0 == vShaderID || 0 == gShaderID || 0 == fShaderID) {
        std::cout << "无法创建着色器程序" << std::endl;
        return 0;
    }
    
    //声明一个着色器程序对象引用ID
    GLuint programID;
    //创建着色器程序
    programID = glCreateProgram();
    //添加顶点着色器
    glAttachShader(programID, vShaderID);
    //添加几何着色器
    glAttachShader(programID, gShaderID);
    //添加片段着色器
    glAttachShader(programID, fShaderID);
    //链接着色器程序
    glLinkProgram(programID);
    //检查着色器链接是否出错
    checkShaderError(programID, ShaderTypeProgram);
    
    return programID;
}
GLint Shader::uniformLocation(const std::string &name) const
{
    if (name.empty() || 0 == _programID) {
        return -1;
    }
    GLint location = glGetUniformLocation(_programID, name.c_str());
    return location;
}
GLuint Shader::uniformBlockIndex(const std::string &name) const
{
    if (name.empty() || 0 == _programID) {
        return 0;
    }
    GLuint index = glGetUniformBlockIndex(_programID, name.c_str());
    return index;
}
void Shader::removeShader(GLuint shaderID, ShaderType type) const
{
    if (type == ShaderTypeProgram) {
        glDeleteProgram(shaderID);
    } else {
        glDeleteShader(shaderID);
    }
}
bool Shader::checkShaderError(GLuint shaderID, ShaderType type) const
{
    GLint isSuccess = 0;
    GLchar infoLog[LOG_BUF_LEN];
    
    if (type == ShaderTypeProgram) {
        //获取着色器程序链接状态
        glGetProgramiv(shaderID, GL_LINK_STATUS, &isSuccess);
        //链接失败
        if (!isSuccess) {
            //获取失败信息
            glGetProgramInfoLog(shaderID, LOG_BUF_LEN, NULL, infoLog);
            std::cout << "链接着色器失败：\n" << infoLog << std::endl;
        }
    } else {
        //获取编译状态
        glGetShaderiv(shaderID, GL_COMPILE_STATUS, &isSuccess);
        //编译失败
        if (!isSuccess) {
            //获取失败信息
            glGetShaderInfoLog(shaderID, LOG_BUF_LEN, NULL, infoLog);
            if (type == ShaderTypeVertex) {
                std::cout << "编译顶点着色器失败：\n" << infoLog << std::endl;
            } else if (type == ShaderTypeGeometry) {
                std::cout << "编译几何着色器失败：\n" << infoLog << std::endl;
            } else if (type == ShaderTypeVertex){
                std::cout << "编译片段着色器失败：\n" << infoLog << std::endl;
            }
        }
    }
    
    return isSuccess;
}
#pragma mark - Public
Shader::Shader(const char *vertexPath, const char *fragmentPath)
{
    //从文件中读取顶点/片段着色器代码
    std::string vertexCode;
    std::string fragmentCode;
    std::ifstream vShaderFile;
    std::ifstream fShaderFile;
    
    //确保 ifstream 对象可以抛出异常
    vShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    fShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    
    //读取 GLSL
    try {
        //打开文件
        vShaderFile.open(vertexPath);
        fShaderFile.open(fragmentPath);
        
        std::stringstream vShaderStream, fShaderStream;
        
        //读取文件流
        vShaderStream << vShaderFile.rdbuf();
        fShaderStream << fShaderFile.rdbuf();
        
        //关闭文件
        vShaderFile.close();
        fShaderFile.close();
        
        //文件流转成 String 字符串
        vertexCode = vShaderStream.str();
        fragmentCode = fShaderStream.str();
    } catch (std::ifstream::failure e) {
        std::cout << "读取 GLSL 文件失败" << std::endl;
    }
    //String 字符串转成 const GLchar*
    const char *vShaderCode = vertexCode.c_str();
    const char *fShaderCode = fragmentCode.c_str();
    
    //创建着色器
    GLuint vShaderID = createShader(vShaderCode, ShaderTypeVertex);
    GLuint fShaderID = createShader(fShaderCode, ShaderTypeFragment);
    
    //创建着色器程序
    _programID = createProgram(vShaderID, fShaderID);
    
    //移除着色器
    removeShader(vShaderID, ShaderTypeVertex);
    removeShader(fShaderID, ShaderTypeFragment);
}
Shader::Shader(const GLchar* vertexPath, const GLchar* geometryPath, const GLchar *fragmentPath)
{
    //从文件中读取顶点/片段着色器代码
    std::string vertexCode;
    std::string geometryCode;
    std::string fragmentCode;
    
    std::ifstream vShaderFile;
    std::ifstream gShaderFile;
    std::ifstream fShaderFile;
    
    //确保 ifstream 对象可以抛出异常
    vShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    gShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    fShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    
    //读取 GLSL
    try {
        //打开文件
        vShaderFile.open(vertexPath);
        gShaderFile.open(geometryPath);
        fShaderFile.open(fragmentPath);
        
        std::stringstream vShaderStream, gShaderStream, fShaderStream;
        
        //读取文件流
        vShaderStream << vShaderFile.rdbuf();
        gShaderStream << gShaderFile.rdbuf();
        fShaderStream << fShaderFile.rdbuf();
        
        //关闭文件
        vShaderFile.close();
        gShaderFile.close();
        fShaderFile.close();
        
        //文件流转成 String 字符串
        vertexCode = vShaderStream.str();
        geometryCode = gShaderStream.str();
        fragmentCode = fShaderStream.str();
    } catch (std::ifstream::failure e) {
        std::cout << "读取 GLSL 文件失败" << std::endl;
    }
    //String 字符串转成 const GLchar*
    const char *vShaderCode = vertexCode.c_str();
    const char *gShaderCode = geometryCode.c_str();
    const char *fShaderCode = fragmentCode.c_str();
    
    //创建着色器
    GLuint vShaderID = createShader(vShaderCode, ShaderTypeVertex);
    GLuint gShaderID = createShader(gShaderCode, ShaderTypeGeometry);
    GLuint fShaderID = createShader(fShaderCode, ShaderTypeFragment);
    
    //创建着色器程序
    _programID = createProgram(vShaderID, gShaderID, fShaderID);
    
    //移除着色器
    removeShader(vShaderID, ShaderTypeVertex);
    removeShader(gShaderID, ShaderTypeGeometry);
    removeShader(fShaderID, ShaderTypeFragment);
}
Shader::~Shader()
{
//    if (_programID != 0) {
//        removeShader(_programID, ShaderTypeProgram);
//    }
}

void Shader::use() const
{
    glUseProgram(_programID);
}

void Shader::setBool(const std::string &name, GLboolean value) const
{
    setInt(name, (GLint)value);
}
void Shader::setInt(const std::string &name, GLint value) const
{
    use();
    glUniform1i(uniformLocation(name), value);
}
void Shader::setFloat(const std::string &name, GLfloat value) const
{
    use();
    glUniform1f(uniformLocation(name), value);
}

void Shader::setVec2f(const std::string &name, glm::vec2 &value) const
{
    use();
    glUniform2fv(uniformLocation(name), 1, &value[0]);
}
void Shader::setVec2f(const std::string &name, GLfloat x, GLfloat y) const
{
    use();
    glUniform2f(uniformLocation(name), x, y);
}

void Shader::setVec3f(const std::string &name, glm::vec3 &value) const
{
    use();
    glUniform3fv(uniformLocation(name), 1, &value[0]);
}
void Shader::setVec3f(const std::string &name, GLfloat x, GLfloat y, GLfloat z) const
{
    use();
    glUniform3f(uniformLocation(name), x, y, z);
}

void Shader::setVec4f(const std::string &name, glm::vec4 &value) const
{
    use();
    glUniform4fv(uniformLocation(name), 1, &value[0]);
}
void Shader::setVec4f(const std::string &name, GLfloat x, GLfloat y, GLfloat z, GLfloat w) const
{
    use();
    glUniform4f(uniformLocation(name), x, y, z, w);
}

void Shader::setMat2fv(const std::string &name, glm::mat2 &value) const
{
    setMat2fv(name, &value[0][0]);
}
void Shader::setMat2fv(const std::string &name, GLfloat *value) const
{
    use();
    glUniformMatrix2fv(uniformLocation(name), 1, GL_FALSE, value);
}

void Shader::setMat3fv(const std::string &name, glm::mat3 &value) const
{
    setMat3fv(name, &value[0][0]);
}
void Shader::setMat3fv(const std::string &name, GLfloat *value) const
{
    use();
    glUniformMatrix3fv(uniformLocation(name), 1, GL_FALSE, value);
}

void Shader::setMat4fv(const std::string &name, glm::mat4 &value) const
{
    setMat4fv(name, &value[0][0]);
}
void Shader::setMat4fv(const std::string &name, GLfloat *value) const
{
    use();
    glUniformMatrix4fv(uniformLocation(name), 1, GL_FALSE, value);
}

void Shader::setBlockBindingPoint(const std::string &name, GLuint bindingPoint)
{
    use();
    glUniformBlockBinding(_programID, uniformBlockIndex(name), bindingPoint);
}
