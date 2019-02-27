//
//  Mesh.hpp
//  OpenGL
//
//  Created by wxh on 2019/2/26.
//  Copyright © 2019 wxh. All rights reserved.
//

#ifndef Mesh_hpp
#define Mesh_hpp
#include <iostream>
#include <glad/glad.h>
#include <glm/glm.hpp>
#include <vector>

#include "Shader.hpp"

/*
 *C++结构体有个特性，它们的内存布局是连续的（sequential）
 */

//顶点属性
struct VertexInfo {
    glm::vec3 position;         //位置
    glm::vec3 normal;           //法线向量
    glm::vec2 texCoords;        //纹理坐标
    glm::vec3 tangent;          //切线向量
    glm::vec3 bitangent;        //副切线向量
};

//纹理属性
struct TextureInfo {
    GLuint id;              //纹理ID
    std::string type;       //纹理类型（漫反射贴图：texture_diffuse、镜面反射贴图：texture_specular)
    std::string path;       //纹理图片路径（用于与其他纹理进行比较）
};

class Mesh {
private:
    /* 渲染数据 */
    GLuint _VAO;
    GLuint _VBO;
    GLuint _EBO;
    
    /* 网格数据 */
    std::vector<VertexInfo> _vertices;      //顶点
    std::vector<GLuint> _indices;           //索引
    std::vector<TextureInfo> _textures;     //纹理
    
    /**
     设置网格数据
     */
    void setupMesh();
    
public:
    Mesh(std::vector<VertexInfo> vertices, std::vector<GLuint> indices, std::vector<TextureInfo> textures);
    ~Mesh();
    
    /**
     获取网格 VAO

     @return 网格 VAO
     */
    GLuint VAO() const;
    
    /**
     获取网格 VBO
     
     @return 网格 VBO
     */
    GLuint VBO() const;
    
    /**
     获取网格 EBO
     
     @return 网格 EBO
     */
    GLuint EBO() const;
    
    /**
     获取网格 顶点

     @return 网格 顶点
     */
    std::vector<VertexInfo> vertices() const;
    
    /**
     获取网格 索引
     
     @return 网格 索引
     */
    std::vector<GLuint> indices() const;
    
    /**
     获取网格 纹理
     
     @return 网格 纹理
     */
    std::vector<TextureInfo> textures() const;
    
    
    void draw(Shader shader);
};

#endif /* Mesh_hpp */
