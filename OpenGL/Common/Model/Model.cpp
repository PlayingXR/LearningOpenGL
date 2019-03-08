//
//  Model.cpp
//  OpenGL
//
//  Created by wxh on 2019/2/26.
//  Copyright © 2019 wxh. All rights reserved.
//

#include "Model.hpp"
#include "Texture.hpp"

#pragma mark - Private

/**
 创建一个Cube
 */
void Model::createCubeModel()
{
    float vertices[] = {
        // positions          // normals           // texture coords
        
        //右
        0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
        
        //左
        -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
        -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
        
        //上
        -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
        
        //下
        -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 0.0f,
        
        //前
        -0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 0.0f,
        
        //后
        0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 0.0f,
        0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 0.0f,
    };
    
    for (int i = 0; i < 6; ++i) {
        std::vector<VertexInfo> verticeInfos;
        std::vector<GLuint> indices;
        std::vector<TextureInfo> textureInfos;
        
        for (int j = 0; j < 4; ++j) {
            int index = i * 8 * 4 + j * 8;
            VertexInfo vertexInfo;
            vertexInfo.position = glm::vec3(vertices[index], vertices[index + 1], vertices[index + 2]);
            vertexInfo.normal = glm::vec3(vertices[index]+3, vertices[index + 4], vertices[index + 5]);
            vertexInfo.texCoords = glm::vec2(vertices[index + 6], vertices[index + 7]);
            verticeInfos.push_back(vertexInfo);
        }

        indices.push_back(0);
        indices.push_back(1);
        indices.push_back(2);
        indices.push_back(2);
        indices.push_back(3);
        indices.push_back(0);
        
        Mesh mesh(verticeInfos, indices, textureInfos);
        _meshs.push_back(mesh);
    }
}

/**
 创建一个Plane
 */
void Model::createPlaneModel()
{
    float vertices[] = {
        // positions            // normals              // texture coords
        -0.5f,  0.5f,  0.0f,  0.0f,  0.0f, 1.0f,   0.0f, 1.0f,
        -0.5f, -0.5f,  0.0f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,
        0.5f, -0.5f,  0.0f,  0.0f,  0.0f, 1.0f,   1.0f, 0.0f,
        0.5f,  0.5f,  0.0f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
    };
    
    std::vector<VertexInfo> verticeInfos;
    std::vector<GLuint> indices;
    std::vector<TextureInfo> textureInfos;
    
    for (int i = 0; i < 4; ++i) {
        int index = i * 8;
        VertexInfo vertexInfo;
        vertexInfo.position = glm::vec3(vertices[index+0], vertices[index + 1], vertices[index + 2]);
        vertexInfo.normal = glm::vec3(vertices[index]+3, vertices[index + 4], vertices[index + 5]);
        vertexInfo.texCoords = glm::vec2(vertices[index + 6], vertices[index + 7]);
        verticeInfos.push_back(vertexInfo);
    }
    
    indices.push_back(0);
    indices.push_back(1);
    indices.push_back(2);
    indices.push_back(2);
    indices.push_back(3);
    indices.push_back(0);
    
    Mesh mesh(verticeInfos, indices, textureInfos);
    _meshs.push_back(mesh);
}

void Model::createSkyboxModel()
{
    float vertices[] = {
         1.0,    1.0,   1.0,
        -1.0,    1.0,   1.0,
        -1.0,   -1.0,   1.0,
         1.0,   -1.0,   1.0,
         1.0,   -1.0,  -1.0,
         1.0,    1.0,  -1.0,
        -1.0,    1.0,  -1.0,
        -1.0,   -1.0,  -1.0,
    };
    
    int indices[] = {
        0, 1, 2,   0, 2, 3,    // 前
        0, 3, 4,   0, 4, 5,    // 右
        0, 5, 6,   0, 6, 1,    // 上
        1, 6, 7,   1, 7, 2,    // 左
        7, 4, 3,   7, 3, 2,    // 下
        4, 7, 6,   4, 6, 5     // 后
    };
    
    std::vector<VertexInfo> verticeInfos;
    std::vector<GLuint> indiceInfos;
    std::vector<TextureInfo> textureInfos;
    
    for (int i = 0; i < 8; ++i) {
        int index = i * 3;
        VertexInfo vertexInfo;
        vertexInfo.position = glm::vec3(vertices[index+0], vertices[index + 1], vertices[index + 2]);
        verticeInfos.push_back(vertexInfo);
    }
    for (int i = 0; i < 36; ++i) {
        indiceInfos.push_back(indices[i]);
    }
    
    Mesh mesh(verticeInfos, indiceInfos, textureInfos);
    _meshs.push_back(mesh);
}

void Model::createScreenModel()
{
    float vertices[] = {
        // positions            // normals              // texture coords
        -1.0f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,   0.0f, 1.0f,
        -1.0f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,
        1.0f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,   1.0f, 0.0f,
        1.0f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
    };
    
    std::vector<VertexInfo> verticeInfos;
    std::vector<GLuint> indices;
    std::vector<TextureInfo> textureInfos;
    
    for (int i = 0; i < 4; ++i) {
        int index = i * 8;
        VertexInfo vertexInfo;
        vertexInfo.position = glm::vec3(vertices[index+0], vertices[index + 1], vertices[index + 2]);
        vertexInfo.normal = glm::vec3(vertices[index]+3, vertices[index + 4], vertices[index + 5]);
        vertexInfo.texCoords = glm::vec2(vertices[index + 6], vertices[index + 7]);
        verticeInfos.push_back(vertexInfo);
    }
    
    indices.push_back(0);
    indices.push_back(1);
    indices.push_back(2);
    indices.push_back(2);
    indices.push_back(3);
    indices.push_back(0);
    
    Mesh mesh(verticeInfos, indices, textureInfos);
    _meshs.push_back(mesh);
}
/**
 加载模型文件，存储所有网格数据
 
 @param path 模型文件路径
 */
void Model::loadModel(std::string const &path)
{
    Assimp::Importer importer;
    
    /*加载模型文件到 scene 中
     *aiProcess_Triangulate：设定Assimp，如果模型不是（全部）由三角形组成，需要将模型的所有图元形状转变成三角形。
     *aiProcess_FlipUVs：设定Assimp，在处理UV的时候翻转Y轴的纹理坐标（即，纹理图像上下倒转）
     *aiProcess_CalcTangentSpace：设定Assimp，计算切线空间
     */
    const aiScene* scene = importer.ReadFile(path, aiProcess_Triangulate | aiProcess_FlipUVs | aiProcess_CalcTangentSpace);
    
    if (!scene || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode) {
        std::cout << "Assimp 导入模型文件失败：" << importer.GetErrorString() << std::endl;
        return;
    }
    //保存文件路径目录
    _directory = path.substr(0, path.find_last_of('/'));
    
    processNode(scene->mRootNode, scene);
}

/**
 递归处理节点
 
 @param node 节点
 @param scene 场景
 */
void Model::processNode(aiNode* node, const aiScene* scene)
{
    //处理节点所有的网格（如果有的话）
    for (unsigned int i = 0; i < node->mNumMeshes; ++i) {
        aiMesh* mesh = scene->mMeshes[node->mMeshes[i]];
        _meshs.push_back(processMesh(mesh, scene));
    }
    //遍历所有节点，获取对应的网格（Mesh）
    for (unsigned int i = 0; i < node->mNumChildren; ++i) {
        processNode(node->mChildren[i], scene);
    }
}

/**
 处理网格（Mesh），获取顶点数据、索引、材质属性...
 
 @param mesh 网格
 @param scene 场景
 @return 自定义网格
 */
Mesh Model::processMesh(aiMesh* mesh, const aiScene* scene)
{
    //数据填充
    std::vector<VertexInfo> vertices;       //顶点
    std::vector<unsigned int> indices;  //索引
    std::vector<TextureInfo> textures;      //纹理
    
    //遍历网格中的所有的顶点
    for (unsigned int i = 0; i < mesh->mNumVertices; i++) {
        //由于Assimp内置的Vector不能直接转换成glm::vec3,所以需要使用一个临时变量来转换
        
        //顶点处理
        VertexInfo vertex;
        glm::vec3 vector;
        
        //顶点
        vector.x = mesh->mVertices[i].x;
        vector.y = mesh->mVertices[i].y;
        vector.z = mesh->mVertices[i].z;
        vertex.position = vector;
        
        //法线
        vector.x = mesh->mNormals[i].x;
        vector.y = mesh->mNormals[i].y;
        vector.z = mesh->mNormals[i].z;
        vertex.normal = vector;
        
        //UV
        if (mesh->mTextureCoords[0]) {      //判断Mesh是否含有UV
            glm::vec2 vec;
            
            //Assimp允许一个模型在一个顶点上最多有8个不同的纹理UV
            //暂时用不到那么多，所以只选择第一组UV
            vec.x = mesh->mTextureCoords[0][i].x;
            vec.y = mesh->mTextureCoords[0][i].y;
            vertex.texCoords = vec;
        } else {
            vertex.texCoords = glm::vec2(0.0f, 0.0f);
        }
        
        //切线
        if (mesh->mTangents) {
            vector.x = mesh->mTangents[i].x;
            vector.y = mesh->mTangents[i].y;
            vector.z = mesh->mTangents[i].z;
            vertex.tangent = vector;
        }
        
        //副切线
        if (mesh->mBitangents) {
            vector.x = mesh->mBitangents[i].x;
            vector.y = mesh->mBitangents[i].y;
            vector.z = mesh->mBitangents[i].z;
            vertex.bitangent = vector;
        }
        
        //将处理好的顶点添加到顶点数组中
        vertices.push_back(vertex);
    }
    /*
     *索引处理
     *Assimp的接口定义了每个网格都有一个面（Face）数组，每个面代表了一个图元，
     *一个面包含了多个索引，每个索引定义了在每个图元中应该绘制哪个顶点，以及绘制的顺序
     */
    //索引
    for (unsigned int i = 0; i < mesh->mNumFaces; ++i) {
        aiFace face = mesh->mFaces[i];
        //遍历每个Face的所有索引并添加到 索引数组 中
        for (unsigned int j = 0; j < face.mNumIndices; ++j) {
            indices.push_back(face.mIndices[j]);
        }
    }
    
    //处理材质
    //材质
    aiMaterial* material = scene->mMaterials[mesh->mMaterialIndex];
    
    /*
     *对于着色器中的纹理采样器（sampler）的名字做如下规定：
     *1、漫反射纹理：texture_diffuseN
     *2、镜面反射纹理：texture_specularN
     *3、法线纹理：texture_normal
     *4、高度贴图：texture_heightN
     *其中 N 序号表示从 1 开始，到最大支持的纹理采样器的数量（MAX_SAMPLER_NUMBER）
     */
    
    //漫反射贴图
    std::vector<TextureInfo> diffuseMaps = loadMaterialTextures(material, aiTextureType_DIFFUSE, "texture_diffuse");
    textures.insert(textures.end(), diffuseMaps.begin(), diffuseMaps.end());
    
    //镜面反射贴图
    std::vector<TextureInfo> specularMaps = loadMaterialTextures(material, aiTextureType_SPECULAR, "texture_specular");
    textures.insert(textures.end(), specularMaps.begin(), specularMaps.end());
    
    //法线贴图
    std::vector<TextureInfo> normalMaps = loadMaterialTextures(material, aiTextureType_NORMALS, "texture_normal");
    textures.insert(textures.end(), normalMaps.begin(), normalMaps.end());
    
    //高度贴图
    std::vector<TextureInfo> heightMaps = loadMaterialTextures(material, aiTextureType_HEIGHT, "texture_height");
    textures.insert(textures.end(), heightMaps.begin(), heightMaps.end());
    
    //解析完网格数据，创建Mesh对象
    return Mesh(vertices, indices, textures);
}

/**
 加载材质纹理数据
 
 @param material 材质
 @param type 纹理类型
 @param typeName 纹理名称
 @return 纹理数组
 */
std::vector<TextureInfo> Model::loadMaterialTextures(aiMaterial* material, aiTextureType type, std::string typeName)
{
    std::vector<TextureInfo> textures;
    
    //检查存储在材质中纹理的数量
    for (unsigned int i = 0; i < material->GetTextureCount(type); ++i) {
        aiString str;
        //获取纹理文件的位置
        material->GetTexture(type, i, &str);
        
        //检查纹理文件是否已经加载
        bool skip = false;
        for (unsigned int j = 0; j < _texturesLoaded.size(); ++j) {
            if (0 == std::strcmp(_texturesLoaded[j].path.data(), str.C_Str())) {
                //纹理文件已经加载，直接冲‘已经加载的纹理数组’添加到‘纹理数组’中‘，优化了再次加载纹理
                textures.push_back(_texturesLoaded[j]);
                skip = true;
                break;
            }
        }
        //判断纹理是否已经加载
        if (!skip) {
            TextureInfo texture;
            texture.id = textureFromFile(str.C_Str(), _directory);
            texture.type = typeName;
            texture.path = str.C_Str();
            textures.push_back(texture);
            //把加载的纹理添加到‘已经加载的纹理数组‘中
            _texturesLoaded.push_back(texture);
        }
    }
    return textures;
}

/**
 创建纹理对象
 
 @param path 纹理图片路径
 @param directory 纹理资源目录
 @param isGamma 是否需要gamma计算
 @return 纹理对象引用 ID
 */
GLuint Model::textureFromFile(const char* path, const std::string &directory, bool isGamma)
{
    std::string filename = std::string(path);
    filename = directory + '/' + filename;
    
    //创建纹理
    Texture texture(filename.c_str());
    texture.setWrap(GL_REPEAT, GL_REPEAT);
    texture.setFilter(GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR);
    
    return texture.textureID();
}

#pragma mark - Public
Model::Model(std::string const &path, bool isGamma)
{
    _isGammaCorrection = isGamma;
    loadModel(path);
}
Model::Model(Geometry geometry)
{
    if (geometry == GeometryCube) {
        createCubeModel();
    } else if (geometry == GeometryPlane) {
        createPlaneModel();
    } else if (geometry == GeometrySkybox) {
        createSkyboxModel();
    } else if (geometry == GeometryScreen) {
        createScreenModel();
    }
}

Model::~Model()
{
    
}

/**
 获取网格
 
 @return 网格数组
 */
std::vector<Mesh> Model::meshes() const
{
    return _meshs;
}

/**
 绘制模型
 
 @param shader 模型对应的着色器
 */
void Model::draw(const Shader &shader)
{
    for (GLuint i = 0; i < _meshs.size(); ++i) {
        _meshs[i].draw(shader);
    }
}
