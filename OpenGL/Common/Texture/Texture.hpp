//
//  Texture.hpp
//  OpenGL
//
//  Created by wxh on 2019/2/21.
//  Copyright © 2019 wxh. All rights reserved.
//

#ifndef Texture_hpp
#define Texture_hpp

#include <glad/glad.h>
#include <vector>

typedef enum TextureType
{
    TextureType2D = 0,  //纹理类型 2D
    TextureType3D = 1,  //纹理类型 3D
}TextureType;

class Texture
{
private:
    /* 纹理类型 */
    TextureType _textureType;
    
    /* 纹理对象 ID */
    GLuint _textureID;
    
    /**
     创建2D纹理

     @param imagePath 图片（纹理）路径
     @return 纹理对象引用 ID
     */
    GLuint createTexture(const GLchar* imagePath) const;
    
    /**
     创建2D纹理

     @param imagePath 图片（纹理）路径
     @param internalFormat 纹理（内部存储）格式
     @param pixelFormat 图片（数据类型）格式
     @return 纹理对象引用 ID
     */
    GLuint createTexture(const GLchar* imagePath, GLint internalFormat, GLenum pixelFormat) const;
    
    /**
     创建3D纹理

     @param cubeImagePaths 所有图片（6个纹理）路径，顺序：右、左、上、下、后、前
     @return 纹理对象引用 ID
     */
    GLuint createTexture(std::vector<std::string> cubeImagePaths) const;
    
    /**
     获取图片格式

     @param colorChannels 颜色通道数
     @return 图片格式
     */
    GLenum getFormat(GLint colorChannels) const;
    
public:
    
    /**
     创建2D纹理构造函数

     @param imagePath 图片（纹理）路径
     */
    Texture(const GLchar* imagePath);
    
    /**
     创建2D纹理构造函数

     @param imagePath 图片（纹理）路径
     @param internalFormat 纹理（内部存储）格式
     @param pixelFormat 图片（数据类型）格式
     */
    Texture(const GLchar* imagePath, GLint internalFormat, GLenum pixelFormat);
    
    /**
     创建3D纹理构造函数

     @param cubeImagePaths 所有图片（6个纹理）路径，顺序：右、左、上、下、后、前
     */
    Texture(std::vector<std::string> cubeImagePaths);
    
    ~Texture();
    
    /**
     获取纹理对象ID

     @return 纹理对象引用ID
     */
    GLuint textureID() const;
    
    /**
     激活并绑定纹理到指定的纹理单元

     @param unit 纹理单元（'GL_TEXTURE0' —— 'GL_TEXTUREMaxUnit'）
     */
    void use(GLenum unit) const;
    
    /**
     释放纹理
     */
    void freeTexture();
    
    /**
     设置2D纹理环绕方式

     @param sWrap S 轴环绕方式
     @param tWrap T 轴环绕方式
     */
    void setWrap(GLint sWrap, GLint tWrap) const;
    
    /**
     设置3D纹理环绕方式

     @param sWrap S 轴环绕方式
     @param tWrap T 轴环绕方式
     @param rWrap R 轴环绕方式
     */
    void setWrap(GLint sWrap, GLint tWrap, GLint rWrap) const;
    
    /**
     设置纹理过滤方式

     @param minFilter 缩小过滤方式
     @param magFilter 放大过滤方式
     */
    void setFilter(GLint minFilter, GLint magFilter) const;
};
#endif /* Texture_hpp */
