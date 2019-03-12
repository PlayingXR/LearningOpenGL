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
//        glfwWindowHint(GLFW_SAMPLES, 4);
        
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

        Shader objectShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/object.vs",
//                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/object.gs",
                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/object.fs");
        
        Shader skyboxShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/skybox.vs",
                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/skybox.fs");
        
        Shader screenShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffersScreen.vs",
                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffersScreen.fs");
        
        std::vector<std::string> faces{
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/right.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/left.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/top.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/bottom.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/front.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/back.jpg",
        };

        Texture cubeMap(faces);

        skyboxShader.setInt("skybox", 0);
        objectShader.setInt("skybox", 1);
        screenShader.setInt("screenTexture", 0);
        
        Model box(GeometryCube);
        
        Model skybox(GeometrySkybox);
        Model screen(GeometryScreen);
        
//        把顶点着色器的Uniform块设置为绑定点0
        objectShader.setBlockBindingPoint("Matrices", 0);
        skyboxShader.setBlockBindingPoint("Matrices", 0);
        
        //开启MSAA
//        glEnable(GL_MULTISAMPLE);
        
        //创建一个FBO
        unsigned int frameBuffer;
        glGenFramebuffers(1, &frameBuffer);

        //绑定到帧缓冲
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);

        //创建多重采样纹理缓冲
        unsigned int textureColorBufferMultiSampled;
        glGenTextures(1, &textureColorBufferMultiSampled);
        //绑定到纹理缓冲
        glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, textureColorBufferMultiSampled);
        //纹理分配内存
        glTexImage2DMultisample(GL_TEXTURE_2D_MULTISAMPLE, 4, GL_RGB, SCR_WIDTH, SCR_HEIGHT, GL_TRUE);
        glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, 0);

        glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, 0);

        //把纹理缓冲装配到帧缓冲的颜色附件GL_COLOR_ATTACHMENT0上
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D_MULTISAMPLE, textureColorBufferMultiSampled, 0);

        //创建一个渲染缓冲对象
        unsigned int rbo;
        glGenRenderbuffers(1, &rbo);

        //绑定到渲染缓冲
        glBindRenderbuffer(GL_RENDERBUFFER, rbo);

        //分配存储
        glRenderbufferStorageMultisample(GL_RENDERBUFFER, 4, GL_DEPTH24_STENCIL8, SCR_WIDTH, SCR_HEIGHT);

        //解除渲染缓冲绑定
        glBindRenderbuffer(GL_RENDERBUFFER, 0);

        //把渲染缓冲对象装配到GL_DEPTH_STENCIL_ATTACHMENT上
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo);

        //检查帧缓冲是否完整
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
            std::cout << "ERROR::FRAMEBUFFER:: Framebuffer is not complete!" << std::endl;
        }

        //解绑帧缓冲
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
        
        //创建一个中间FBO用于还原多倍采样
        unsigned int intermediateFBO;
        glGenFramebuffers(1, &intermediateFBO);
        glBindFramebuffer(GL_FRAMEBUFFER, intermediateFBO);
        
        unsigned int screenTexture;
        glGenTextures(1, &screenTexture);
        glBindTexture(GL_TEXTURE_2D, screenTexture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, SCR_WIDTH, SCR_HEIGHT, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, screenTexture, 0);
        
        //检查帧缓冲是否完整
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
            std::cout << "ERROR::FRAMEBUFFER:: Framebuffer is not complete!" << std::endl;
        }
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        
        //创建ubo
        unsigned int uboMatrices;
        //创建
        glGenBuffers(1, &uboMatrices);
        glBindBuffer(GL_UNIFORM_BUFFER, uboMatrices);
        glBufferData(GL_UNIFORM_BUFFER, 2 * sizeof(glm::mat4), NULL, GL_STATIC_DRAW);
        glBindBuffer(GL_UNIFORM_BUFFER, 0);
        glBindBufferRange(GL_UNIFORM_BUFFER, 0, uboMatrices, 0, 2 * sizeof(glm::mat4));

        //启用深度测试
        glEnable(GL_DEPTH_TEST);
        //在片段深度值小于缓冲的深度值时通过测试
        glDepthFunc(GL_LESS);

        //开启混合
        glEnable(GL_BLEND);

        //设置混合因子
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
//        也可以使用glBlendFuncSeparate为RGB和alpha通道分别设置不同的选项
        glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ZERO);
        
//        设置运算符
        glBlendEquation(GL_FUNC_ADD);
        
        //启用面剔除
//        glEnable(GL_CULL_FACE);
//
//        //设置剔除背面
//        glCullFace(GL_BACK);
        
        
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
            
            //渲染指令
            //glClearColor是一个状态设置函数，清除屏幕颜色为（0.2，0.3，0.3，1.0）
            glClearColor(0.0, 0.0, 0.0, 1.0f);
            
            //glClear是一个状态使用函数，清除颜色缓冲、深度缓冲、模板缓冲
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
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

            glm::mat4 view = camera.viewMatrix();
            glm::mat4 projection = glm::perspective(glm::radians(fov), (float)SCR_WIDTH/(float)SCR_HEIGHT, 0.1f, 100.0f);

            //为ubo填充数据
            glBindBuffer(GL_UNIFORM_BUFFER, uboMatrices);//把uboMatrices绑定Uniform缓冲
            glBufferSubData(GL_UNIFORM_BUFFER, 0, sizeof(glm::mat4), glm::value_ptr(view));//根据block中的布局先设置view，再设置projection
            glBufferSubData(GL_UNIFORM_BUFFER, sizeof(glm::mat4), sizeof(glm::mat4), glm::value_ptr(projection));
            glBindBuffer(GL_UNIFORM_BUFFER, 0);//释放绑定

            glm::mat4 model = glm::mat4(1.0f);

            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.0f, 3.0f, 0.0f));
//            model = glm::scale(model, glm::vec3(1.0f, 1.0f, 1.0f));
            objectShader.setMat4fv("model", model);
            box.draw(objectShader);
            glBindVertexArray(0);
            
            glBindFramebuffer(GL_READ_FRAMEBUFFER, frameBuffer);
            glBindFramebuffer(GL_DRAW_FRAMEBUFFER, intermediateFBO);
            glBlitFramebuffer(0, 0, SCR_WIDTH, SCR_HEIGHT, 0, 0, SCR_WIDTH, SCR_HEIGHT, GL_COLOR_BUFFER_BIT, GL_NEAREST);
            
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            glDisable(GL_DEPTH_TEST);

            glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);

            screenShader.use();
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, screenTexture);
            screen.draw(screenShader);
            
            //渲染天空盒
//            glDepthFunc(GL_LEQUAL);
//            glCullFace(GL_FRONT);
//            cubeMap.use(GL_TEXTURE0);
//            skybox.draw(skyboxShader);
//            glCullFace(GL_BACK);
//            glDepthFunc(GL_LESS);

            //检查有没有什么出发事件（键盘输入，鼠标移动等）
            glfwPollEvents();
            
            //切换双缓冲buffer
            glfwSwapBuffers(window);
        }
        
        //当渲染循环结束后我们需要正确释放所有资源
        glfwTerminate();
        return 0;
    }
    return 0;
}


