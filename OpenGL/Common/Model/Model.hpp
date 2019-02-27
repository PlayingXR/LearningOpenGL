//
//  Model.hpp
//  OpenGL
//
//  Created by wxh on 2019/2/26.
//  Copyright © 2019 wxh. All rights reserved.
//

#ifndef Model_hpp
#define Model_hpp

#include <iostream>
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
#include "Shader.hpp"
#include "Mesh.hpp"

class Model
{
private:
    
    std::vector<TextureInfo> _texturesLoaded;   //纹理（存储所有已经加载的纹理，避免多次加载消耗性能）
    std::vector<Mesh> _meshs;               //网格
    std::string _directory;                 //模型文件路径的目录
    bool _isGammaCorrection;                  //gamma矫正
    
    /**
     加载模型文件，存储所有网格数据

     @param path 模型文件路径
     */
    void loadModel(std::string const &path);
    
    /**
     递归处理节点

     @param node 节点
     @param scene 场景
     */
    void processNode(aiNode* node, const aiScene* scene);
    
    /**
     处理网格（Mesh），获取顶点数据、索引、材质属性...

     @param mesh 网格
     @param scene 场景
     @return 自定义网格
     */
    Mesh processMesh(aiMesh* mesh, const aiScene* scene);
    
    /**
     加载材质纹理数据

     @param material 材质
     @param type 纹理类型
     @param typeName 纹理名称
     @return 纹理数组
     */
    std::vector<TextureInfo> loadMaterialTextures(aiMaterial* material, aiTextureType type, std::string typeName);
    
    /**
     创建纹理对象

     @param path 纹理图片路径
     @param directory 纹理资源目录
     @param isGamma 是否需要gamma计算
     @return 纹理对象引用 ID
     */
    GLuint textureFromFile(const char* path, const std::string &directory, bool isGamma = false);
public:
    Model(std::string const &path, bool isGamma = false);
    ~Model();
    
    /**
     获取网格

     @return 网格数组
     */
    std::vector<Mesh> meshes() const;
    
    /**
     绘制模型

     @param shader 模型对应的着色器
     */
    void draw(const Shader &shader);
};

#endif /* Model_hpp */
