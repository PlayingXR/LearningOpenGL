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


const unsigned int SCR_WIDTH = 1600;
const unsigned int SCR_HEIGHT = 1200;

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

bool isBlinn = true;

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
//            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
            isBlinn = false;
        }
    }
    if (glfwGetKey(window, GLFW_KEY_2) == GLFW_PRESS) {
        isLineModel = false;
        if (!isLineModel) {
            isLineModel = true;
//            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
            isBlinn = true;
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
        
        GLFWwindow *window = glfwCreateWindow(SCR_WIDTH/2.0, SCR_HEIGHT/2.0, "LearnOpenGL", NULL, NULL);
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

        Shader objectShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/shader.vs",
                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/shader.fs");
        
        Shader skyboxShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/skybox.vs",
                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/skybox.fs");
        
        Shader screenShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffersScreen.vs",
                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/framebuffersScreen.fs");
        
        Shader shadowMappingShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/shadowMapping.vs",
                                   "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/shadowMapping.fs");
        
        Shader debugShadowMappingShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/debugShadowMapping.vs",
                                        "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/debugShadowMapping.fs");
        
        std::vector<std::string> faces{
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/right.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/left.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/top.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/bottom.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/front.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/back.jpg",
        };

        Texture cubeMap(faces);
        
        Texture planeMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/wood.png");

        skyboxShader.setInt("skybox", 0);
        screenShader.setInt("screenTexture", 0);
        objectShader.setInt("skybox", 1);
        objectShader.setInt("texture_diffuse1", 0);
        objectShader.setInt("texture_depth", 2);
        
        debugShadowMappingShader.setInt("depthMap", 0);
        
        Model plane(GeometryPlane);
        Model skybox(GeometrySkybox);
        Model screen(GeometryScreen);
        Model box(GeometryCube);
        
        
        glm::vec3 lightPos(-2.0f, 4.0f, -1.0f);
        
//        把顶点着色器的Uniform块设置为绑定点0
        objectShader.setBlockBindingPoint("Matrices", 0);
        skyboxShader.setBlockBindingPoint("Matrices", 0);
        
        GLuint depthMapFBO;
        //创建一个帧缓冲
        glGenFramebuffers(1, &depthMapFBO);
        const GLuint SHADOW_WIDTH = 1024, SHADOW_HEIGHT = 1024;

        GLuint depthMap;
        //创建
        glGenTextures(1, &depthMap);
        //绑定
        glBindTexture(GL_TEXTURE_2D, depthMap);
        //分配内存，但是不填充
        glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, SHADOW_WIDTH, SHADOW_HEIGHT, 0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL);
        //设置滤波
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        //设置环绕
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
        GLfloat borderColor[] = {1.0, 1.0, 1.0, 1.0};
        glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);

        //绑定帧缓冲
        glBindFramebuffer(GL_FRAMEBUFFER, depthMapFBO);
        //装配深度缓冲属性
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthMap, 0);
        //不设置颜色缓冲
        glDrawBuffer(GL_NONE);
        glReadBuffer(GL_NONE);
        //释放绑定
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        
        //开启MSAA
//        glEnable(GL_MULTISAMPLE);
        
        //创建ubo
        unsigned int uboMatrices;
        //创建
        glGenBuffers(1, &uboMatrices);
        glBindBuffer(GL_UNIFORM_BUFFER, uboMatrices);
        glBufferData(GL_UNIFORM_BUFFER, 3 * sizeof(glm::mat4), NULL, GL_STATIC_DRAW);
        glBindBuffer(GL_UNIFORM_BUFFER, 0);
        glBindBufferRange(GL_UNIFORM_BUFFER, 0, uboMatrices, 0, 3 * sizeof(glm::mat4));

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
            
            //渲染指令
            //glClearColor是一个状态设置函数，清除屏幕颜色为（0.2，0.3，0.3，1.0）
            glClearColor(0.0, 0.0, 0.0, 1.0f);

            //glClear是一个状态使用函数，清除颜色缓冲、深度缓冲、模板缓冲
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

            glm::mat4 lightProjection, lightView;
            glm::mat4 lightSpaceMatrix;
            float nearPlane = 1.0f, farPlane = 7.5f;
            lightProjection = glm::ortho(-10.0f, 10.0f, -10.0f, 10.0f, nearPlane, farPlane);
            lightView = glm::lookAt(lightPos, glm::vec3(0.0f), glm::vec3(0.0, 1.0, 0.0));
            lightSpaceMatrix = lightProjection * lightView;

            shadowMappingShader.setMat4fv("lightSpaceMatrix", lightSpaceMatrix);

            //生成深度贴图
            glViewport(0, 0, SHADOW_WIDTH, SHADOW_HEIGHT);
            glBindFramebuffer(GL_FRAMEBUFFER, depthMapFBO);
            glClear(GL_DEPTH_BUFFER_BIT);
//            glCullFace(GL_FRONT);

            //渲染场景
            glm::mat4 model = glm::mat4(1.0f);
            model = glm::rotate(model, glm::radians(-90.0f), glm::vec3(1.0, 0.0, 0.0));
            model = glm::scale(model, glm::vec3(10.0f));
            shadowMappingShader.setMat4fv("model", model);
            plane.draw(shadowMappingShader);

            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.0, 0.5f, 0.0));
            shadowMappingShader.setMat4fv("model", model);
            box.draw(shadowMappingShader);

            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.2, 2.0f, 0.0));
            shadowMappingShader.setMat4fv("model", model);
            box.draw(shadowMappingShader);
            glBindVertexArray(0);

            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            
            //使用深度贴图
            glViewport(0, 0, SCR_WIDTH, SCR_HEIGHT);
            
            //启用深度测试
            glEnable(GL_DEPTH_TEST);

            //渲染指令
            //glClearColor是一个状态设置函数，清除屏幕颜色为（0.2，0.3，0.3，1.0）
            glClearColor(0.0, 0.0, 0.0, 1.0f);

            //glClear是一个状态使用函数，清除颜色缓冲、深度缓冲、模板缓冲
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
            glCullFace(GL_BACK);
            
            //禁用深度写入
            //            glDepthMask(GL_FALSE);
            
            glm::mat4 view = camera.viewMatrix();
            glm::mat4 projection = glm::perspective(glm::radians(fov), (float)SCR_WIDTH/(float)SCR_HEIGHT, 0.1f, 100.0f);

            //为ubo填充数据
            glBindBuffer(GL_UNIFORM_BUFFER, uboMatrices);//把uboMatrices绑定Uniform缓冲
            glBufferSubData(GL_UNIFORM_BUFFER, 0, sizeof(glm::mat4), glm::value_ptr(view));//根据block中的布局先设置view，再设置projection
            glBufferSubData(GL_UNIFORM_BUFFER, sizeof(glm::mat4), sizeof(glm::mat4), glm::value_ptr(projection));
            glBufferSubData(GL_UNIFORM_BUFFER, 2 * sizeof(glm::mat4), sizeof(glm::mat4), glm::value_ptr(lightSpaceMatrix));
            glBindBuffer(GL_UNIFORM_BUFFER, 0);//释放绑定
            
            
            glActiveTexture(GL_TEXTURE2);
            glBindTexture(GL_TEXTURE_2D, depthMap);
            planeMap.use(GL_TEXTURE0);
            
            glm::vec3 position = camera.position();
            
            objectShader.setVec3f("viewPos", position);
            objectShader.setVec3f("lightPos", lightPos);
            
            //渲染场景
            model = glm::mat4(1.0f);
            model = glm::rotate(model, glm::radians(-90.0f), glm::vec3(1.0, 0.0, 0.0));
            model = glm::scale(model, glm::vec3(10.0f));
            objectShader.setMat4fv("model", model);
            
            //            //法线矩阵
            model = glm::inverse(model);    //逆矩阵
            model = glm::transpose(model);  //转置矩阵
            objectShader.setMat4fv("normal", model);
            
            plane.draw(objectShader);
            
            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.0, 0.5f, 0.0));
            objectShader.setMat4fv("model", model);
            
            //            //法线矩阵
            model = glm::inverse(model);    //逆矩阵
            model = glm::transpose(model);  //转置矩阵
            objectShader.setMat4fv("normal", model);
            
            box.draw(objectShader);
            
            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.2, 2.0f, 0.0));
            objectShader.setMat4fv("model", model);
            
            //            //法线矩阵
            model = glm::inverse(model);    //逆矩阵
            model = glm::transpose(model);  //转置矩阵
            objectShader.setMat4fv("normal", model);
            
            box.draw(objectShader);
//            debugShadowMappingShader.setFloat("near_Plane", nearPlane);
//            debugShadowMappingShader.setFloat("far_Plane", farPlane);
            //使用深度贴图
//            glActiveTexture(GL_TEXTURE0);
//            glBindTexture(GL_TEXTURE_2D, depthMap);
//            screen.draw(debugShadowMappingShader);
            
//            glBindVertexArray(0);

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


