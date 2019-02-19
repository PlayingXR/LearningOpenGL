//
//  Camera.hpp
//  OpenGL
//
//  Created by wxh on 2019/1/29.
//  Copyright © 2019 wxh. All rights reserved.
//

#ifndef Camera_hpp
#define Camera_hpp

#include <glm/glm.hpp>
#include <glad/glad.h>
#include <iostream>

/* 移动方向枚举 */
typedef enum MoveDirection {
    MoveDirectionForward         = 0,    //向‘前’移动
    MoveDirectionBackwrad        = 1,    //向‘后’移动
    MoveDirectionLeft            = 2,    //向’左‘移动
    MoveDirectionRight           = 3,    //向‘右’移动
    MoveDirectionUp              = 4,    //向‘上’移动
    MoveDirectionDown            = 5,    //向‘下’移动
}MoveDirection;

/* 摄像机默认值 */
const GLfloat kYaw          = -90.0f;   //偏航角
const GLfloat kPitch        = 0.0f;     //俯仰角
const GLfloat kSpeed        = 2.5f;     //移动速度
const GLfloat kSensitivity  = 0.1f;     //敏感度
const GLfloat kZoom         = 45.0f;    //缩放

class Camera {
private:
    /* 摄像机属性 */
    glm::mat4 _viewMatrix;          //观察矩阵
    glm::vec3 _position;            //摄像机位置
    glm::vec3 _front;               //摄像机‘前’向量
    glm::vec3 _right;               //摄像机‘右’向量
    glm::vec3 _up;                  //摄像机‘上’向量
    glm::vec3 _worldUp;              //世界空间‘上’向量
    
    /* 欧拉角 */
    GLfloat _yaw;           //偏航角
    GLfloat _pitch;         //俯仰角
    
    /* 摄像机选项 */
    GLfloat _speed;         //移动速度
    GLfloat _sensitivity;   //鼠标灵敏度
    GLfloat _zoom;          //缩放
    
    glm::mat4 createLookAt(glm::vec3 position, glm::vec3 target, glm::vec3 worldUp);
    
    /* 更新摄像机 front、right、up向量 */
    void updateCameraVectors();
    
public:
    /* 构造函数 */
    Camera(glm::vec3 position = glm::vec3(0.0f, 0.0f, 0.0f),
           glm::vec3 up = glm::vec3(0.0f, 1.0f, 0.0f),
           float yaw = kYaw,
           float pitch = kPitch);
    
    Camera(float posX,
           float posY,
           float posZ,
           float upX,
           float upY,
           float upZ,
           float yaw,
           float pitch);
    
    /* 析构函数 */
    ~Camera();
    
    /**
     使用摄像机（观察矩阵）

     @return 观察矩阵
     */
    GLfloat* use();
    
    /**
     获取（观察矩阵）视野（Filed Of View)

     @return 视野角度(弧度制)
     */
    GLfloat fov() const;
    
    /**
     获取观察矩阵

     @return 观察矩阵
     */
    glm::mat4 viewMatrix();
    
    /**
     获取摄像机‘位置’

     @return 位置
     */
    glm::vec3 position() const;
    
    /**
     获取摄像机‘前’向量

     @return 前向量
     */
    glm::vec3 front() const;
    
    /**
     获取摄像机‘上’向量

     @return 上向量
     */
    glm::vec3 up() const;
    
    /**
     获取摄像机‘右’向量

     @return 右向量
     */
    glm::vec3 right() const;
    
    /**
     获取摄像机定义的世界空间‘上’向量

     @return 世界空间’上‘向量
     */
    glm::vec3 worldUp() const;
    
    /**
     获取摄像机偏航角

     @return 偏航角（弧度制）
     */
    GLfloat yaw() const;
    
    /**
     获取摄像机俯仰角

     @return 俯仰角（弧度制）
     */
    GLfloat pitch() const;
    
    void keyboardMove(MoveDirection direction, float deltaTime);
    void mouseMove(float xoffset, float yoffset, bool constrainPitch = true);
    void mouseScroll(float yoffset);
};
#endif /* Camera_hpp */
