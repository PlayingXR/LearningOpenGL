//
//  main.m
//  OpenGL
//
//  Created by wxh on 2018/11/27.
//  Copyright © 2018 wxh. All rights reserved.
//
#include <iostream>
#include <cmath>

#include <glad/glad.h>
#include <GLFW/glfw3.h>

//#include "assimp/scene.h"
//#include "assimp/postprocess.h"

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <vector>

#include "Shader.hpp"
#include "Camera.hpp"
#include "Texture.hpp"

#include "DirectionLight.hpp"
#include "PointLight.hpp"
#include "Spotlight.hpp"
#include "Mesh.hpp"
#include "Model.hpp"


const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

bool isLineModel = false;

float mixValue = 0.5;
float x = 0.0f;
float y = 0.0f;
float z = -3.0f;

float fov = 45.0f;

float speed = 25.0f;

float deltaTime = 0.0f; //当前帧与上一帧的时间差
float lastFrame = 0.0f; //上一帧的时间

float lastX = SCR_WIDTH / 2.0f;
float lastY = SCR_HEIGHT / 2.0f;

float pitch = 0.0f;
float yaw = 0.0f;

float shininess = 32.0f;
float specularStrength = 0.5f;

bool firstMouse = true;

glm::vec3 cameraPos = glm::vec3(0.0f, 0.0f, 3.0f);
glm::vec3 cameraFront = glm::vec3(0.0f, 0.0f, -1.0f);
glm::vec3 cameraUp = glm::vec3(0.0f, 1.0f, 0.0f);

Camera camera(glm::vec3(3.0f, 3.0f, 10.0f));

//窗口大小改变的回调
void framebuffer_size_callback(GLFWwindow *window, int width, int height)
{
    glViewport(0, 0, width, height);
}
//处理输入事件
void processInput(GLFWwindow *window)
{
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
    if (glfwGetKey(window, GLFW_KEY_1) == GLFW_PRESS) {
        isLineModel = true;
        if (isLineModel) {
            isLineModel = false;
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        }
    }
    if (glfwGetKey(window, GLFW_KEY_2) == GLFW_PRESS) {
        isLineModel = false;
        if (!isLineModel) {
            isLineModel = true;
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
        }

    }
    
    if (glfwGetKey(window, GLFW_KEY_DOWN) == GLFW_PRESS) {
//        mixValue -= 0.001f;
//
//        if (mixValue <= 0.0f) {
//            mixValue = 0.0f;
//        }
        shininess -= 0.1f;
        if (shininess <= 1.0f) {
            shininess = 1.0f;
        }
    }
    if (glfwGetKey(window, GLFW_KEY_LEFT) == GLFW_PRESS) {
        specularStrength -= 0.001f;

        if (specularStrength <= 0.0f) {
            specularStrength = 0.0f;
        }
    }
    
    if (glfwGetKey(window, GLFW_KEY_RIGHT) == GLFW_PRESS) {
        specularStrength += 0.001f;
        if (specularStrength >= 1.0f) {
            specularStrength = 1.0f;
        }
    }
    if (glfwGetKey(window, GLFW_KEY_UP) == GLFW_PRESS) {
        //        mixValue += 0.001f;
        //
        //        if (mixValue >= 1.0f) {
        //            mixValue = 1.0f;
        //        }
        shininess += 0.1f;
        if (shininess >= 100.0f) {
            shininess = 100.0f;
        }
    }
    
    if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)
        camera.keyboardMove(MoveDirectionForward, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS)
        camera.keyboardMove(MoveDirectionBackwrad, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS)
         camera.keyboardMove(MoveDirectionLeft, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS)
        camera.keyboardMove(MoveDirectionRight, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_E) == GLFW_PRESS)
        camera.keyboardMove(MoveDirectionUp, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_Q) == GLFW_PRESS)
        camera.keyboardMove(MoveDirectionDown, deltaTime);
}

void mouse_callback(GLFWwindow* window, double xpos, double ypos) {
    if (firstMouse) {
        lastX = xpos;
        lastY = ypos;
        firstMouse = false;
    }
    
    float xoffset = xpos - lastX;
    float yoffset = lastY - ypos;
    
    lastX = xpos;
    lastY = ypos;
    
    camera.mouseMove(xoffset, yoffset);
}

void scroll_callback(GLFWwindow* window, double xoffset, double yoffset) {
    camera.mouseScroll(yoffset);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        glfwInit();
        
        //初始化GLFW
        //glfwWindowHint函数的第一个参数代表选项的名称，第二个参数是设置第一项的值
        //GLFW_CONTEXT_VERSION_MAJOR使用的主版本号：3
        //GLFW_CONTEXT_VERSION_MINOR使用的次版本号：3
        //所以告诉GLFW我们要使用的OpenGl的版本号是3.3
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        //GLFW_OPENGL_PROFILE指定开发模式是核心模式,去掉了向后兼容的特性
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        
        GLFWwindow *window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
        if (window == NULL) {
            std::cout << "Failed to create GLFW window" << std::endl;
            glfwTerminate();
            return -1;
        }
        glfwMakeContextCurrent(window);
//        glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
        
        //在调用任何OpenGL的函数之前我们需要初始化GLAD
        if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
            std::cout << "Faild to initialize GLAD" << std::endl;
            return -1;
        }
        
        glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
        glfwSetCursorPosCallback(window, mouse_callback);
        glfwSetScrollCallback(window, scroll_callback);
        
        int nrAttributes;
        glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &nrAttributes);
        std::cout << "Maximum nr of vertex attributes supported: " << nrAttributes << std::endl;
        
        Shader objectShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffers.vs", "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffers.fs");
        
        
        Shader screenShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffersScreen.vs", "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffersScreen.fs");
        
        Texture boxTexture("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/container.jpg");
        Texture planeTexture("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/metal.png");
        
        objectShader.setInt("texture_diffuse", 0);
        
        Model cube(GeometryCube);
        Model plane(GeometryPlane);
        Model screen(GeometryScreen);
        
        screenShader.setInt("screenTexture", 0);
        //创建一个FBO
        unsigned int frameBuffer;
        glGenFramebuffers(1, &frameBuffer);

        //绑定到帧缓冲
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);

        //创建纹理缓冲
        unsigned int textureColorBuffer;
        glGenTextures(1, &textureColorBuffer);
        //绑定到纹理缓冲
        glBindTexture(GL_TEXTURE_2D, textureColorBuffer);
        //纹理分配内存
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, SCR_WIDTH, SCR_HEIGHT, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);

        //设置滤波
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        //解除纹理绑定
        glBindTexture(GL_TEXTURE_2D, 0);

        //把纹理缓冲装配到帧缓冲的颜色附件GL_COLOR_ATTACHMENT0上
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureColorBuffer, 0);
        
        //创建一个渲染缓冲对象
        unsigned int rbo;
        glGenRenderbuffers(1, &rbo);
        
        //绑定到渲染缓冲
        glBindRenderbuffer(GL_RENDERBUFFER, rbo);
        
        //分配存储
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, SCR_WIDTH, SCR_HEIGHT);
        //解除渲染缓冲绑定
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
        
        //把渲染缓冲对象装配到GL_DEPTH_STENCIL_ATTACHMENT上
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo);
        
        //检查帧缓冲是否完整
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
            std::cout << "ERRO::FRAMEBUFFER:: Framebuffer is not complete!" << std::endl;
        }
        //激活默认帧缓冲
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        //启用深度测试
        glEnable(GL_DEPTH_TEST);
        //在片段深度值小于缓冲的深度值时通过测试
        glDepthFunc(GL_LESS);
        
        //开启混合
        glEnable(GL_BLEND);
        
        //设置混合因子
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        //也可以使用glBlendFuncSeparate为RGB和alpha通道分别设置不同的选项
//        glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ZERO);
        
        //设置运算符
//        glBlendEquation(GL_FUNC_ADD);
        
        //启用面剔除
        glEnable(GL_CULL_FACE);
        
        //设置剔除背面
        glCullFace(GL_BACK);
        
        //指定逆时针环绕顺序为前面
        //GL_CCW：逆时针环绕顺序
        //GL_CW：顺时针环绕顺序
//        glFrontFace(GL_CCW);
        
        //使用while循环来不断的渲染画面，我们称之为渲染循环（Render Loop）
        //没次循环开始之前检查一次GLFW是否被要求退出
        while (!glfwWindowShouldClose(window)) {
            float currentFrame = glfwGetTime();
            deltaTime = currentFrame - lastFrame;
            lastFrame = currentFrame;
            
            //输入
            processInput(window);
            
            glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);

            //启用深度测试
            glEnable(GL_DEPTH_TEST);
            
            //渲染指令
            //glClearColor是一个状态设置函数，清除屏幕颜色为（0.2，0.3，0.3，1.0）
            glClearColor(0.0, 0.0, 0.0, 1.0f);
            
            //glClear是一个状态使用函数，清除颜色缓冲、深度缓冲、模板缓冲
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
            //禁用深度写入
//            glDepthMask(GL_FALSE);
            
            glm::vec3 cameraPostion = camera.position();

            glm::mat4 view = camera.viewMatrix();
            objectShader.setMat4fv("view", glm::value_ptr(view));
            
            glm::mat4 projection = glm::perspective(glm::radians(fov), (float)SCR_WIDTH/(float)SCR_HEIGHT, 0.1f, 100.0f);
            objectShader.setMat4fv("projection", glm::value_ptr(projection));

            glm::mat4 model = glm::mat4(1.0f);
            
            objectShader.use();
            model = glm::mat4(1.0f);
            model = glm::rotate(model, glm::radians(-90.0f), glm::vec3(1.0f, 0.0f, 0.0f));
            model = glm::scale(model, glm::vec3(20.0f, 20.0f, 1.0f));
            objectShader.setMat4fv("model", glm::value_ptr(model));
            
            //法线矩阵
            model = glm::inverse(model);    //逆矩阵
            model = glm::transpose(model);  //转置矩阵
            objectShader.setMat4fv("normal", glm::value_ptr(model));

            planeTexture.use(GL_TEXTURE0);
            plane.draw(objectShader);
            
            glBindVertexArray(0);
            
            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.0f, 0.51f, 0.0f));
            objectShader.setMat4fv("model", glm::value_ptr(model));
            
            //法线矩阵
            model = glm::inverse(model);    //逆矩阵
            model = glm::transpose(model);  //转置矩阵
            objectShader.setMat4fv("normal", glm::value_ptr(model));

            boxTexture.use(GL_TEXTURE0);
            cube.draw(objectShader);
            
            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.7f, 0.51f, -0.7f));
            objectShader.setMat4fv("model", glm::value_ptr(model));
            
            boxTexture.use(GL_TEXTURE0);
            cube.draw(objectShader);
            glBindVertexArray(0);
            
            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.0f, 0.51f, 2.0f));
            objectShader.setMat4fv("model", glm::value_ptr(model));
            
            //法线矩阵
            model = glm::inverse(model);    //逆矩阵
            model = glm::transpose(model);  //转置矩阵
            objectShader.setMat4fv("normal", glm::value_ptr(model));
            
            boxTexture.use(GL_TEXTURE0);
            plane.draw(objectShader);
            glBindVertexArray(0);
            
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            glDisable(GL_DEPTH_TEST);

            glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);

            screenShader.use();
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, textureColorBuffer);
            screen.draw(screenShader);
            
            //检查有没有什么出发事件（键盘输入，鼠标移动等）
            glfwPollEvents();
            
            //切换双缓冲buffer
            glfwSwapBuffers(window);
        }
        glDeleteFramebuffers(1, &frameBuffer);
        glDeleteBuffers(1, &quadVBO);
        
        //当渲染循环结束后我们需要正确释放所有资源
        glfwTerminate();
        return 0;
    }
    return 0;
}


