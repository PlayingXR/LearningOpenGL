//
//  Texture.cpp
//  OpenGL
//
//  Created by wxh on 2019/2/21.
//  Copyright © 2019 wxh. All rights reserved.
//

#include "Texture.hpp"
#include <iostream>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#pragma mark - Private
GLuint Texture::createTexture(const GLchar* imagePath) const
{
    if (NULL == imagePath) {
        return 0;
    }
    //声明一个引用纹理对象 ID
    GLuint textureID;
    //创建纹理对象
    glGenTextures(1, &textureID);
    //绑定2D纹理对象
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    GLint imgWidth;            //图片高度
    GLint imgHeight;           //图片高度
    GLint colorChannels;    //图片颜色通道数
    //加载图片
    GLubyte* imgData = stbi_load(imagePath, &imgWidth, &imgHeight, &colorChannels, 0);
    //设置图片倒转
    stbi_set_flip_vertically_on_load(true);
    if (!imgData) {
        std::cout << "加载2D纹理失败！" << std::endl;
    } else {
        GLenum format = getFormat(colorChannels);
        
        //生成纹理
        glTexImage2D(GL_TEXTURE_2D, 0, format, imgWidth, imgHeight, 0, format, GL_UNSIGNED_BYTE, imgData);
        //生成多级纹理
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    //释放图片内存
    stbi_image_free(imgData);
    return textureID;
}

GLuint Texture::createTexture(const GLchar* imagePath, GLint internalFormat, GLenum pixelFormat) const
{
    if (NULL == imagePath) {
        return 0;
    }
    //声明一个引用纹理对象 ID
    GLuint textureID;
    //创建纹理对象
    glGenTextures(1, &textureID);
    //绑定2D纹理对象
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    GLint imgWidth;            //图片高度
    GLint imgHeight;           //图片高度
    GLint colorChannels;    //图片颜色通道数
    //加载图片
    GLubyte* imgData = stbi_load(imagePath, &imgWidth, &imgHeight, &colorChannels, 0);
    //设置图片倒转
    stbi_set_flip_vertically_on_load(true);
    if (!imgData) {
        std::cout << "加载2D纹理失败！" << std::endl;
    } else {
        //生成纹理
        glTexImage2D(GL_TEXTURE_2D, 0, internalFormat, imgWidth, imgHeight, 0, pixelFormat, GL_UNSIGNED_BYTE, imgData);
        //生成多级纹理
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    //释放图片内存
    stbi_image_free(imgData);
    return textureID;
}

GLuint Texture::createTexture(std::vector<std::string> cubeImagePaths) const
{
    GLint count = (GLint)cubeImagePaths.size();
    if (0 >= count) {
        return 0;
    }
    //声明一个引用 纹理对象 ID
    GLuint textureID;
    //创建纹理对象
    glGenTextures(1, &textureID);
    //绑定3D纹理对象
    glBindTexture(GL_TEXTURE_CUBE_MAP, textureID);
    
    GLint imgWidth;            //图片高度
    GLint imgHeight;           //图片高度
    GLint colorChannels;    //图片颜色通道数
    
    //加载纹理
    for (GLint i = 0; i < count; i++) {
        //禁止图片倒转
        stbi_set_flip_vertically_on_load(false);
        //加载图片
        GLubyte* imgData = stbi_load(cubeImagePaths[i].c_str(), &imgWidth, &imgHeight, &colorChannels, 0);
        if (!imgData) {
            std::cout << "加载3D纹理:" << i << " 失败！" << std::endl;
        } else {
            GLenum format = getFormat(colorChannels);
            //生成纹理
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0 ,format, imgWidth, imgHeight, 0, format, GL_UNSIGNED_BYTE, imgData);
        }
        //释放图片内存
        stbi_image_free(imgData);
    }
    return textureID;
}

GLenum Texture::getFormat(GLint colorChannels) const
{
    GLenum format = GL_RGB;
    if (1 == colorChannels)
        format = GL_RED;
    else if (3 == colorChannels)
        format = GL_RGB;
    else if (4 == colorChannels)
        format = GL_RGBA;
    return format;
}

#pragma mark - Public
Texture::Texture(const GLchar* imagePath)
{
    if (NULL == imagePath) {
        std::cout << "图片路径不存在，无法创建纹理！" << std::endl;
        return;
    }
    _textureID = createTexture(imagePath);
    _textureType = TextureType2D;
    
    setWrap(GL_REPEAT, GL_REPEAT);
    setFilter(GL_LINEAR, GL_LINEAR);
}

Texture::Texture(const GLchar* imagePath, GLint internalFormat, GLenum pixelFormat)
{
    if (NULL == imagePath) {
        std::cout << "图片路径不存在，无法创建纹理！" << std::endl;
        return;
    }
    _textureID = createTexture(imagePath, internalFormat, pixelFormat);
    _textureType = TextureType2D;
    
    setWrap(GL_REPEAT, GL_REPEAT);
    setFilter(GL_LINEAR, GL_LINEAR);
}

Texture::Texture(std::vector<std::string> cubeImagePaths)
{
    if (6 != cubeImagePaths.size()) {
        std::cout << "图片的数量没有达到6张，无法创建3D纹理！" << std::endl;
        return;
    }
    _textureID = createTexture(cubeImagePaths);
    _textureType = TextureType3D;
    
    setWrap(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
    setFilter(GL_LINEAR, GL_LINEAR);
}

Texture::~Texture()
{
    freeTexture();
}

GLuint Texture::textureID() const
{
    return _textureID;
}
void Texture::use(GLenum unit) const
{
    //先激活对应的纹理单元
    glActiveTexture(unit);
    //绑定纹理
    if (_textureType == TextureType2D) {
        glBindTexture(GL_TEXTURE_2D, _textureID);
    } else {
        glBindTexture(GL_TEXTURE_CUBE_MAP, _textureID);
    }
}
void Texture::freeTexture()
{
    if (0 != _textureID) {
        glDeleteTextures(1, &_textureID);
    }
}
void Texture::setWrap(GLint sWrap, GLint tWrap) const
{
    //先绑定纹理
    glBindTexture(GL_TEXTURE_2D, _textureID);
    //设置S轴环绕方式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, sWrap);
    //设置T轴环绕方式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, tWrap);
}
void Texture::setWrap(GLint sWrap, GLint tWrap, GLint rWrap) const
{
    //先绑定纹理
    glBindTexture(GL_TEXTURE_CUBE_MAP, _textureID);
    //设置S轴环绕方式
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, sWrap);
    //设置T轴环绕方式
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, tWrap);
    //设置R轴环绕方式
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, rWrap);
}

void Texture::setFilter(GLint minFilter, GLint magFilter) const
{
    if (TextureType2D == _textureType) {
        //先绑定纹理
        glBindTexture(GL_TEXTURE_2D, _textureID);
        //设置纹理缩小滤波
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
        //设置纹理放大滤波
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    } else {
        //先绑定纹理
        glBindTexture(GL_TEXTURE_CUBE_MAP, _textureID);
        //设置纹理缩小滤波
        glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, minFilter);
        //设置纹理放大滤波
        glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, magFilter);
    }
}
