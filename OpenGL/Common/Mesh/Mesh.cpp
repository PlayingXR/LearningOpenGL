//
//  Mesh.cpp
//  OpenGL
//
//  Created by wxh on 2019/2/26.
//  Copyright © 2019 wxh. All rights reserved.
//

#include "Mesh.hpp"
#pragma mark - Private
void Mesh::setupMesh()
{
    //创建VAO、VBO、EBO
    glGenVertexArrays(1, &_VAO);
    glGenBuffers(1, &_VBO);
    glGenBuffers(1, &_EBO);
    
    //绑定VAO
    glBindVertexArray(_VAO);
    
    //把VBO绑定到GL_ARRAY_BUFFER目标上
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    //生成buffer
    glBufferData(GL_ARRAY_BUFFER, _vertices.size() * sizeof(VertexInfo), &_vertices[0], GL_STATIC_DRAW);
    
    //把EBO绑定到GL_ELEMENT_ARRAY_BUFFER目标上
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _EBO);
    //生成buffer
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indices.size() * sizeof(GLuint), &_indices[0], GL_STATIC_DRAW);
    
    //顶点位置
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertexInfo), (void*)offsetof(VertexInfo, position));
    //第一个参数：顶点属性，与vertex shader中的location = 0对应
    //第二个参数：每一个顶点属性的分量个数
    //第三个参数：每个分量的类型
    //第四个参数：是否希望s数据被标准化，即映射到0到1之间
    //第五个参数：步长，即每个顶点属性的size
    //第六个参数：位置数据在缓冲中起始位置的偏移量
    
    //法线
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(VertexInfo), (void*)offsetof(VertexInfo, normal));
    //结构体预处理指令 offsetof(s, m)，第一个参数是一个结构体，第二个参数是这个结构体中变量的名字。
    //这个宏会返回那个变量距结构体头部的字节偏移量(Byte Offset)。
    
    //UV
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(VertexInfo), (void*)offsetof(VertexInfo, texCoords));
    
    //切线
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(VertexInfo), (void*)offsetof(VertexInfo, tangent));
    
    //副切线
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 3, GL_FLOAT, GL_FALSE, sizeof(VertexInfo), (void*)offsetof(VertexInfo, bitangent));
    
    //解绑VAO
    glBindVertexArray(0);
}

#pragma mark - Public

/* 网格数据 */
Mesh::Mesh(std::vector<VertexInfo> vertices, std::vector<GLuint> indices, std::vector<TextureInfo> textures)
{
    _vertices = vertices;
    _indices = indices;
    _textures = textures;
    
    setupMesh();
}

Mesh::~Mesh()
{
    //释放资源
//    glDeleteBuffers(1, &_VAO);
//    glDeleteBuffers(1, &_VBO);
//    glDeleteBuffers(1, &_EBO);
}

/**
 获取网格 VAO
 
 @return 网格 VAO
 */
GLuint Mesh::VAO() const
{
    return _VAO;
}

/**
 获取网格 VBO
 
 @return 网格 VBO
 */
GLuint Mesh::VBO() const
{
    return _VBO;
}

/**
 获取网格 EBO
 
 @return 网格 EBO
 */
GLuint Mesh::EBO() const
{
    return _EBO;
}

/**
 获取网格 顶点
 
 @return 网格 顶点
 */
std::vector<VertexInfo> Mesh::vertices() const
{
    return _vertices;
}

/**
 获取网格 索引
 
 @return 网格 索引
 */
std::vector<GLuint> Mesh::indices() const
{
    return _indices;
}

/**
 获取网格 纹理
 
 @return 网格 纹理
 */
std::vector<TextureInfo> Mesh::textures() const
{
    return _textures;
}


void Mesh::draw(Shader shader)
{
    shader.use();
    
    GLuint diffuseNr = 1;
    GLuint specularNr = 1;
    GLuint normalNr = 1;
    GLuint heightNr = 1;

    for (GLuint i = 0; i < _textures.size(); ++i) {
        //在绑定之前先激活响应的纹理单元
        glActiveTexture(GL_TEXTURE0 + i);

        //获取纹理序号（texture_diffuseN 中的N）
        std::string number;
        std::string name = _textures[i].type;

        //转换：数字 -> 字符
        if ("texture_diffuse" == name) {            //漫反射纹理
            number = std::to_string(diffuseNr++);
        } else if ("texture_specular" == name) {    //镜面反射纹理
            number = std::to_string(specularNr++);
        } else if ("texture_normal" == name) {      //法线纹理
            number = std::to_string(normalNr++);
        } else if ("texture_height" == name) {      //高度纹理
            number = std::to_string(heightNr++);
        }

        //设置纹理单元序号
        shader.setInt((name + number).c_str(), i);
        glBindTexture(GL_TEXTURE_2D, _textures[i].id);
    }
    
    //绘制网格
    glBindVertexArray(_VAO);
    glDrawElements(GL_TRIANGLES, (GLsizei)_indices.size(), GL_UNSIGNED_INT, 0);
    //第一个参数：指定绘制模式
    //第二个参数：索引的顶点个数
    //第三个参数：索引的类型
    //第四个参数：EBO中的偏移量
    
    //解绑 VAO
    glBindVertexArray(0);
    //设置回默认值
    glActiveTexture(GL_TEXTURE0);
}
