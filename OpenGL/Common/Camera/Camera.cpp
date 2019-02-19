//
//  Camera.cpp
//  OpenGL
//
//  Created by wxh on 2019/1/29.
//  Copyright © 2019 wxh. All rights reserved.
//

#include "Camera.hpp"
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#pragma mark - Private
glm::mat4 Camera::createLookAt(glm::vec3 position, glm::vec3 target, glm::vec3 worldUp)
{
    /*
     _               _     _              _
     |  Rx  Ry  Rz  0  |   |  1  0  0  -Px  |
     lookAt = |  Ux  Uy  Uz  0  | * |  0  1  0  -Py  |
     |  Dx  Dy  Dz  0  |   |  0  0  1  -Pz  |
     |_ 0   0   0   1 _|   |_ 0  0  0   1  _|
     
     其中 R 是右向量，U 是上向量，D 是方向向量， P是摄像机位置向量。
     注意，位置向量是相反的，因为最终把世界平移到与我们自身移动的相反方向
     */
    
    /* 计算摄像机 Z（方向向量） 轴 */
    glm::vec3 zAxis = glm::normalize(position - target);
    /* 计算摄像机 X 轴（右向量） */
    glm::vec3 xAxis = glm::normalize(glm::cross(glm::normalize(worldUp), zAxis));
    // 4. Calculate camera up vector
    /* 计算摄像机 Y 轴（上向量） */
    glm::vec3 yAxis = glm::cross(zAxis, xAxis);
    
    /* 创建平移矩阵 */
    glm::mat4 translation; /* 创建单位矩阵 */
    translation[3][0] = -position.x;    /* 设置位置向量‘x’ 坐标量 */
    translation[3][1] = -position.y;    /* 设置位置向量‘y’ 坐标量 */
    translation[3][2] = -position.z;    /* 设置位置向量‘z’ 坐标量 */
    
    /* 创建旋转矩阵 */
    glm::mat4 rotation;
    rotation[0][0] = xAxis.x;       /* 设置 X 轴 ‘x’ 坐标量 */
    rotation[1][0] = xAxis.y;       /* 设置 X 轴 ‘y’ 坐标量 */
    rotation[2][0] = xAxis.z;       /* 设置 X 轴 ‘z’ 坐标量 */
    
    rotation[0][1] = yAxis.x;       /* 设置 Y 轴 ‘x’ 坐标量 */
    rotation[1][1] = yAxis.y;       /* 设置 Y 轴 ‘y’ 坐标量 */
    rotation[2][1] = yAxis.z;       /* 设置 Y 轴 ‘z’ 坐标量 */
    
    rotation[0][2] = zAxis.x;       /* 设置 Z 轴 ‘x’ 坐标量 */
    rotation[1][2] = zAxis.y;       /* 设置 Z 轴 ‘y’ 坐标量 */
    rotation[2][2] = zAxis.z;       /* 设置 Z 轴 ‘z’ 坐标量 */
    
    /* 创建 Look At（观察）矩阵 */
    return rotation * translation;
}
void Camera::updateCameraVectors()
{
    glm::vec3 front;
    front.x = cos(glm::radians(_pitch)) * cos(glm::radians(_yaw));
    front.y = sin(glm::radians(_pitch));
    front.z = cos(glm::radians(_pitch)) * sin(glm::radians(_yaw));
    
    /* 更新摄像机 Z（方向向量） 轴 */
    _front = glm::normalize(front);
    /* 更新摄像机 X（右向量） 轴 = 摄像机方向向量 x 世界上向量 */
    _right = glm::normalize(glm::cross(_front, _worldUp));
    /* 更新摄像机 Y（上向量） 轴 = 摄像机右向量 x 摄像机方向向量 */
    _up    = glm::normalize(glm::cross(_right, _front));
}
#pragma mark - Public
Camera::Camera(glm::vec3 position, glm::vec3 up, float yaw, float pitch) : _front(glm::vec3(0.0f, 0.0f, -1.0f)), _speed(kSpeed), _sensitivity(kSensitivity), _zoom(kZoom)
{
    _position   = position;
    _worldUp     = up;
    _yaw        = yaw;
    _pitch      = pitch;
    
    updateCameraVectors();
}
Camera::Camera(float posX, float posY, float posZ, float upX, float upY, float upZ, float yaw, float pitch) : _front(glm::vec3(0.0f, 0.0f, -1.0f)), _speed(kSpeed), _sensitivity(kSensitivity), _zoom(kZoom)
{
    _position   = glm::vec3(posX, posY, posZ);
    _worldUp    = glm::vec3(upX, upY, upZ);
    _yaw        = yaw;
    _pitch      = pitch;
    
    updateCameraVectors();
}
Camera::~Camera() {}

GLfloat* Camera::use()
{
    viewMatrix();
    return glm::value_ptr(_viewMatrix);
}
glm::mat4 Camera::viewMatrix()
{
    _viewMatrix = glm::lookAt(_position, _position + _front, _up);
    return _viewMatrix;
}

GLfloat Camera::fov() const
{
    return glm::radians(_zoom);
}
glm::vec3 Camera::position() const
{
    return _position;
}
glm::vec3 Camera::front() const
{
    return _front;
}
glm::vec3 Camera::up() const
{
    return _up;
}
glm::vec3 Camera::right() const
{
    return _right;
}

void Camera::keyboardMove(MoveDirection direction, float deltaTime) {
    float velocity = _speed * deltaTime;
    
    if (direction == MoveDirectionForward) {
        _position += _front * velocity;
    } else if (direction == MoveDirectionBackwrad) {
        _position -= _front * velocity;
    } else if (direction == MoveDirectionLeft) {
        _position -= _right * velocity;
    } else if (direction == MoveDirectionRight) {
        _position += _right * velocity;
    } else if (direction == MoveDirectionUp) {
        _position += _up * velocity;
    } else if (direction == MoveDirectionDown) {
        _position -= _up * velocity;
    }
}
void Camera::mouseMove(float xoffset, float yoffset, bool constrainPitch) {
    xoffset *= _sensitivity;
    yoffset *= _sensitivity;
    
//#ifdef __APPLE__
//    _yaw -= xoffset;
//    _pitch -= yoffset;
//#else
    _yaw += xoffset;
    _pitch += yoffset;
//#endif
    
    if (constrainPitch) {
        if (_pitch > 89.0f)
            _pitch = 89.0f;
        if (_pitch < -89.0f)
            _pitch = -89.0f;
    }
    updateCameraVectors();
}
void Camera::mouseScroll(float yoffset) {
    if (_zoom >= 1.0f && _zoom <= 45.0f)
        _zoom -= yoffset;
    if (_zoom <= 1.0f)
        _zoom = 1.0f;
    if (_zoom >= 45.0f)
        _zoom = 45.0f;
}
