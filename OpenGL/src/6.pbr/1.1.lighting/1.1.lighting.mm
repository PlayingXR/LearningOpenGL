//
//  main.m
//  OpenGL
//
//  Created by wxh on 2018/11/27.
//  Copyright © 2018 wxh. All rights reserved.
//
#include <iostream>
#include <cmath>
#include <random>

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

float shininess = 5.0f;
float specularStrength = 0.5f;
float heightScale = 0.1f;

bool firstMouse = true;

bool isBlinn = true;

bool hasBloom = false;

float exposure = 1.0f;

float metallic = 0.5f;
float roughness = 0.5f;

glm::vec3 cameraPos = glm::vec3(0.0f, 0.0f, 13.0f);
glm::vec3 cameraFront = glm::vec3(0.0f, 0.0f, 1.0f);
glm::vec3 cameraUp = glm::vec3(0.0f, 1.0f, 0.0f);

Camera camera(glm::vec3(0.0f, 0.0f, 20.0f));

bool hasDisplacement = true;

bool hasSSAO = true;

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
            hasBloom = false;
            hasSSAO = false;
            std::cout << "关闭SSAO" << std::endl;
        }
    }
    if (glfwGetKey(window, GLFW_KEY_2) == GLFW_PRESS) {
        isLineModel = false;
        if (!isLineModel) {
            isLineModel = true;
//            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
            isBlinn = true;
            
            hasBloom = true;
            hasSSAO = true;
            
            std::cout << "开启SSAO" << std::endl;
        }
    }
    if (glfwGetKey(window, GLFW_KEY_UP) == GLFW_PRESS) {
        //        mixValue += 0.001f;
        //
        //        if (mixValue >= 1.0f) {
        //            mixValue = 1.0f;
        //        }
        roughness += 0.01f;
        if (roughness >= 1.0f) {
            roughness = 1.0f;
        }
        std::cout << "roughness: " << roughness << std::endl;
    }
    if (glfwGetKey(window, GLFW_KEY_DOWN) == GLFW_PRESS) {
//        mixValue -= 0.001f;
//
//        if (mixValue <= 0.0f) {
//            mixValue = 0.0f;
//        }
        roughness -= 0.01f;
        if (roughness <= 0.0f) {
            roughness = 0.0f;
        }
        std::cout << "roughness: " << roughness << std::endl;
    }
    if (glfwGetKey(window, GLFW_KEY_LEFT) == GLFW_PRESS) {
        metallic -= 0.01f;

        if (metallic <= 0.0f) {
            metallic = 0.0f;
        }
        std::cout << "metallic: " << metallic << std::endl;
    }
    
    if (glfwGetKey(window, GLFW_KEY_RIGHT) == GLFW_PRESS) {
        metallic += 0.01f;
        if (metallic >= 1.0f) {
            metallic = 1.0f;
        }
        std::cout << "metallic: " << metallic << std::endl;
    }
    
    
    if (glfwGetKey(window, GLFW_KEY_0) == GLFW_PRESS) {
        if (exposure > 0.0f) {
            exposure -= 0.01f;
        } else {
            exposure = 0.0f;
        }
        std::cout << "heightScale: " << exposure << std::endl;
    }
    if (glfwGetKey(window, GLFW_KEY_9) == GLFW_PRESS) {
        if (exposure < 5.0f) {
            exposure += 0.01f;
        } else {
            exposure = 5.0f;
        }
        std::cout << "heightScale: " << exposure << std::endl;
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

float lerp(float a, float b, float f) {
    return a + f * (b - a);
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
        
        Shader lightShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/light.vs",
                           "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/light.fs");
        
        Shader skyboxShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/skybox.vs",
                            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/skybox.fs");
        
        Shader PBRShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/PBR.vs",
                         "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/PBR.fs");
        
        std::vector<std::string> faces{
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/right.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/left.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/top.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/bottom.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/front.jpg",
            "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/skybox/back.jpg",
        };

        Texture cubeMap(faces);
        
        Texture diffuseMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/wood.png");
        Texture normalMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/bricks2_normal.jpg");
        Texture containerMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/container.jpg");
        
        Texture awesomeMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/awesomeface.png");

        skyboxShader.setInt("skybox", 0);

        
        Model skybox(GeometrySkybox);
        Model screen(GeometryScreen);
        Model box(GeometryCube);
        Model nanosuit("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/objects/nanosuit/nanosuit.obj");
        Model plane(GeometryPlane);
        Model planet("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/objects/planet/planet.obj");
        
        Model gltfBox("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/objects/Cube/glTF/Cube.gltf");
        
        glm::vec3 lightPositions[] = {
            glm::vec3(-10.0f,  10.0f, 10.0f),
            glm::vec3( 10.0f,  10.0f, 10.0f),
            glm::vec3(-10.0f, -10.0f, 10.0f),
            glm::vec3( 10.0f, -10.0f, 10.0f),
        };
        glm::vec3 lightColors[] = {
            glm::vec3(300.0f, 300.0f, 300.0f),
            glm::vec3(300.0f, 300.0f, 300.0f),
            glm::vec3(300.0f, 300.0f, 300.0f),
            glm::vec3(300.0f, 300.0f, 300.0f)
        };
        int nrRows    = 7;
        int nrColumns = 7;
        float spacing = 2.5;
        
//        把顶点着色器的Uniform块设置为绑定点0
        PBRShader.setBlockBindingPoint("Matrices", 0);
        skyboxShader.setBlockBindingPoint("Matrices", 0);
        lightShader.setBlockBindingPoint("Matrices", 0);
        
        //开启MSAA
//        glEnable(GL_MULTISAMPLE);
        
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
//        glEnable(GL_BLEND);

        //设置混合因子
//        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

//        也可以使用glBlendFuncSeparate为RGB和alpha通道分别设置不同的选项
//        glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ZERO);

//        设置运算符
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
        
        float lastTime = glfwGetTime();
        int times = 0;
        float nowTime = lastTime;
        
        while (!glfwWindowShouldClose(window)) {
            float currentFrame = glfwGetTime();
            deltaTime = currentFrame - lastFrame;
            lastFrame = currentFrame;
            
            //输入
            processInput(window);

            //FPS:
            times += 1;
            nowTime = glfwGetTime();
            if ((nowTime - lastTime) >= 1.0) {
                std::cout << "FPS: " << times << ", lastTime: " << lastTime << ", nowTime: " <<nowTime << std::endl;
                lastTime = nowTime;
                times = 0;
            }
            
            //渲染指令
            glClearColor(0.0, 0.0, 0.0, 1.0f);

            //glClear是一个状态使用函数，清除颜色缓冲、深度缓冲、模板缓冲
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

//            glCullFace(GL_BACK);
            glEnable(GL_DEPTH_TEST);
//            glEnable(GL_BLEND);
            
            //禁用深度写入
            //            glDepthMask(GL_FALSE);
            
            glm::mat4 view = camera.viewMatrix();
            glm::mat4 projection = glm::perspective(glm::radians(fov), (float)SCR_WIDTH/(float)SCR_HEIGHT, 0.1f, 100.0f);

            //为ubo填充数据
            glBindBuffer(GL_UNIFORM_BUFFER, uboMatrices);//把uboMatrices绑定Uniform缓冲
            glBufferSubData(GL_UNIFORM_BUFFER, 0, sizeof(glm::mat4), glm::value_ptr(view));//根据block中的布局先设置view，再设置projection
            glBufferSubData(GL_UNIFORM_BUFFER, sizeof(glm::mat4), sizeof(glm::mat4), glm::value_ptr(projection));
//            glBufferSubData(GL_UNIFORM_BUFFER, 2 * sizeof(glm::mat4), sizeof(glm::mat4), glm::value_ptr(lightSpaceMatrix));
            glBindBuffer(GL_UNIFORM_BUFFER, 0);//释放绑定
            
            
            glm::vec3 cameraPosition = camera.position();
            
            PBRShader.setVec3f("camPos", cameraPosition);
            
            for (unsigned int i = 0; i < sizeof(lightPositions) / sizeof(lightPositions[0]); i++) {
                glm::vec3 position = lightPositions[i];
                glm::vec3 color = lightColors[i];
                
                PBRShader.setVec3f("lightPositions[" + std::to_string(i) + "]", position);
                PBRShader.setVec3f("lightColors[" + std::to_string(i) + "]", color);
            }
            
            glm::vec3 albedo = glm::vec3(0.5f, 0.0f, 0.0f);
            PBRShader.setVec3f("albedo", albedo);
            PBRShader.setFloat("ao", 1.0f);
            
            glm::mat4 model = glm::mat4(1.0f);
            
//            for (int row = 0; row < nrRows; ++row) {
//                PBRShader.setFloat("metallic", (float)row / (float)nrRows);
//
//                for (int col = 0; col < nrColumns; ++col) {
////                    PBRShader.setFloat("roughness", glm::clamp((float)col / (float)nrColumns, 0.05f, 1.0f));
//
//                    PBRShader.setFloat("roughness", 1.0f);
//
//                    model = glm::mat4(1.0f);
//                    model = glm::translate(model, glm::vec3((col - (nrColumns / 2)) * spacing, (row - (nrRows / 2)) * spacing, 0.0f));
//                    model = glm::scale(model, glm::vec3(0.3f, 0.3f, 0.3f));
//                    PBRShader.setMat4fv("model", model);
//
//                    //            //法线矩阵
//                    model = glm::inverse(model);    //逆矩阵
//                    model = glm::transpose(model);  //转置矩阵
//                    PBRShader.setMat4fv("normal", model);
//
//                    planet.draw(PBRShader);
//                }
//            }
            
            PBRShader.setFloat("metallic", metallic);
            PBRShader.setFloat("roughness", roughness);
            
            model = glm::mat4(1.0f);
            model = glm::translate(model, glm::vec3(0.0f, 0.0f, 0.0f));
            model = glm::scale(model, glm::vec3(1.0f, 1.0f, 1.0f));
            PBRShader.setMat4fv("model", model);
            
            //            //法线矩阵
            model = glm::inverse(model);    //逆矩阵
            model = glm::transpose(model);  //转置矩阵
            PBRShader.setMat4fv("normal", model);
            planet.draw(PBRShader);
            
            
            for (unsigned int i = 0; i < sizeof(lightPositions) / sizeof(lightPositions[0]); i++) {
                glm::vec3 position = lightPositions[i];
                glm::vec3 color = lightColors[i];
                
                lightShader.setVec3f("color", color);
                
                model = glm::mat4(1.0f);
                model = glm::translate(model, position);
                model = glm::scale(model, glm::vec3(1.0f, 1.0f, 1.0f));
                lightShader.setMat4fv("model", model);
                
                //            //法线矩阵
                model = glm::inverse(model);    //逆矩阵
                model = glm::transpose(model);  //转置矩阵
                lightShader.setMat4fv("normal", model);
                planet.draw(lightShader);
            }


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


