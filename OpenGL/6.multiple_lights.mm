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

Camera camera(glm::vec3(0.0f, 0.0f, 3.0f));

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
    if (glfwGetKey(window, GLFW_KEY_TAB) == GLFW_PRESS) {
        isLineModel = !isLineModel;
        if (isLineModel) {
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        } else {
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
    if (glfwGetKey(window, GLFW_KEY_Q) == GLFW_PRESS)
        camera.keyboardMove(MoveDirectionUp, deltaTime);
    if (glfwGetKey(window, GLFW_KEY_E) == GLFW_PRESS)
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

float vertices[] = {
    // positions          // normals           // texture coords
    -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 0.0f,
    0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 0.0f,
    0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 1.0f,
    0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  1.0f, 1.0f,
    -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,  0.0f, 0.0f,
    
    -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,
    0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 0.0f,
    0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
    0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   1.0f, 1.0f,
    -0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 1.0f,
    -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,   0.0f, 0.0f,
    
    -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
    -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
    -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
    -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
    -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
    -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
    
    0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
    0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
    0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
    0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
    0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 0.0f,
    0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 1.0f,
    0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 1.0f,
    0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 0.0f,
    0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  1.0f, 0.0f,
    -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,  0.0f, 1.0f,
    
    -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 1.0f,
    0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 1.0f,
    0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
    0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
    -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 0.0f,
    -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 1.0f
};

unsigned int indices[] = {
    0, 2, 1,
    2, 0, 3
};

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
        
        glViewport(0, 0, SCR_WIDTH, SCR_HEIGHT);
        glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
        glfwSetCursorPosCallback(window, mouse_callback);
        glfwSetScrollCallback(window, scroll_callback);
        
        int nrAttributes;
        glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &nrAttributes);
        std::cout << "Maximum nr of vertex attributes supported: " << nrAttributes << std::endl;
        
        Shader objectShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/shader.vs", "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/shader.fs");
        Shader lightShader("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/light.vs", "/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Shaders/light.fs");

        Texture diffuseMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/container2.png");
        Texture specularMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/container2_specular.png");
        Texture emissionMap("/Users/wxh/Git/GitHub/LearningOpenGL/OpenGL/Resources/textures/matrix.jpg");
        
        DirectionLight directionLight(objectShader, "directionLight");
        
        PointLight pointLight1(objectShader, "pointLight[0]");
        PointLight pointLight2(objectShader, "pointLight[1]");
        PointLight pointLight3(objectShader, "pointLight[2]");
        PointLight pointLight4(objectShader, "pointLight[3]");
        
        Spotlight spotlight(objectShader, "spotlight");

        //创建VAO
        unsigned int VAO, VBO, EBO;
        glGenVertexArrays(1, &VAO);
        glGenBuffers(1, &VBO);
//        glGenBuffers(1, &EBO);
        
        //绑定VAO
        glBindVertexArray(VAO);
        //生成buffer来存顶点，叫VBO
        //把VBO绑定到GL_ARRAY_BUFFER目标上
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        //这样只需要我们往GL_ARRAY_BUFFER目标上写入数据都会缓冲到VBO上
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        
        //绑定EBO
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
//        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
        
        //glBufferData是一个专门把用户定义的数据复制到当前绑定的缓冲的buffer里
        //第一个参数是目标缓冲的类型
        //第二个参数指定传输数据的大小（以字节为单位）sizof可以计算出顶点数据的大小
        //第三个参数是我们发出数据
        //第四个参数是指定显卡如何管理这些数据，它有三种形式：
        //GL_STATIC_DRAW：数据不会或几乎不会改变
        //GL_DYNAMIC_DRAW：数据会改改变很多次
        //GL_STREAM_DRAW：数据每次绘制都会改变
        
        //设置顶点属性指针
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void *)0);
        //第一个参数：顶点属性，与vertex shader中的location = 0对应
        //第二个参数：每一个顶点属性的分量个数
        //第三个参数：每个分量的类型
        //第四个参数：是否希望s数据被标准化，即映射到0到1之间
        //第五个参数：步长，即每个顶点属性的size
        //第六个参数：位置数据在缓冲中起始位置的偏移量
        glEnableVertexAttribArray(0);
        
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void *)(3 * sizeof(float)));
        glEnableVertexAttribArray(1);
        
        glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void *)(6 * sizeof(float)));
        glEnableVertexAttribArray(2);
        
//        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void *)(6 * sizeof(float)));
//        glEnableVertexAttribArray(2);
        
        glBindVertexArray(0);
        
        //lighting
        unsigned int lightVAO;
        glGenVertexArrays(1, &lightVAO);
        glBindVertexArray(lightVAO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        
//        ourShader.setInt("texture1", 0);
//        ourShader.setInt("texture2", 1);
        objectShader.setInt("material.diffuse", 0);
        objectShader.setInt("material.specular", 1);
        objectShader.setInt("material.emission", 2);
        
        //模型矩阵，从模型坐标系转换到世界坐标系
        glm::mat4 model = glm::mat4(1.0f);
//        model = glm::rotate(model, glm::radians(-55.0f), glm::vec3(1.0f, 0.0f, 0.0f));
        
        //视图矩阵，从世界坐标系转换到观察空间
//        glm::mat4 view = glm::mat4(1.0f);
//        view = glm::translate(view, glm::vec3(0.0f, 0.0f, -3.0f));
//
//        glm::vec3 cameraPos = glm::vec3(0.0f, 0.0f, 3.0f);
//        glm::vec3 cameraTarget = glm::vec3(0.0f ,0.0f ,0.0f);
//        glm::vec3 cameraDirection = glm::normalize(cameraPos - cameraTarget);
//
//        glm::vec3 up = glm::vec3(0.0f, 1.0f, 0.0f);
//        glm::vec3 cameraRight = glm::normalize(glm::cross(up, cameraDirection));
//        glm::vec3 cameraUp = glm::cross(cameraDirection, cameraRight);
        
//        glm::mat4 view = glm::lookAt(cameraPos, cameraTarget, up);
        
        //投影矩阵，从裁剪坐标系转换到屏幕坐标系
        glm::mat4 projection = glm::mat4(1.0f);
        projection = glm::perspective(glm::radians(45.0f), (float)SCR_WIDTH / (float)SCR_HEIGHT, 0.1f, 100.0f);
        
        glm::vec3 cubePositions[] = {
            glm::vec3( 0.0f,  0.0f,  0.0f),
            glm::vec3( 2.0f,  5.0f, -15.0f),
            glm::vec3(-1.5f, -2.2f, -2.5f),
            glm::vec3(-3.8f, -2.0f, -12.3f),
            glm::vec3( 2.4f, -0.4f, -3.5f),
            glm::vec3(-1.7f,  3.0f, -7.5f),
            glm::vec3( 1.3f, -2.0f, -2.5f),
            glm::vec3( 1.5f,  2.0f, -2.5f),
            glm::vec3( 1.5f,  0.2f, -1.5f),
            glm::vec3(-1.3f,  1.0f, -1.5f)
        };
        
        glm::vec3 pointLightPositions[] = {
            glm::vec3( 0.7f,  0.2f,  2.0f),
            glm::vec3( 2.3f, -3.3f, -4.0f),
            glm::vec3(-4.0f,  2.0f, -12.0f),
            glm::vec3( 0.0f,  0.0f, -3.0f)
        };
        
        model = glm::rotate(model, glm::radians(0.05f), glm::vec3(0.5f, 1.0f, 0.0f));
        glm::mat4 view = camera.viewMatrix();
        
        objectShader.setMat4fv("model", glm::value_ptr(model));
        objectShader.setMat4fv("view", glm::value_ptr(view));
        objectShader.setMat4fv("projection", glm::value_ptr(projection));
 
        glEnable(GL_DEPTH_TEST);
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
            glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
            
            //glClear是一个状态使用函数，清除深度缓冲
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
//            glActiveTexture(GL_TEXTURE0);
//            glBindTexture(GL_TEXTURE_2D, texture1);
//
//            glActiveTexture(GL_TEXTURE1);
//            glBindTexture(GL_TEXTURE_2D, texture2);

            diffuseMap.use(GL_TEXTURE0);
            specularMap.use(GL_TEXTURE1);
            emissionMap.use(GL_TEXTURE2);

            objectShader.use();
            objectShader.setFloat("mixValue", mixValue);
            
            glm::mat4 view = camera.viewMatrix();
            objectShader.setMat4fv("view", glm::value_ptr(view));
            
            projection = glm::perspective(glm::radians(fov), (float)SCR_WIDTH/(float)SCR_HEIGHT, 0.1f, 100.0f);
            objectShader.setMat4fv("projection", glm::value_ptr(projection));
            
            glBindVertexArray(VAO);
            
//            glDrawArrays(GL_TRIANGLES, 0, 3);
            //第一个参数：绘制图元
            //第二个参数：顶点数组的其实索引
            //第三个参数：需要绘制的顶点个数
            
            objectShader.use();
            for (unsigned int i = 0; i < 10; i++) {
                float angle = 20 + 20.0f * i;
                if (i % 3 == 0) {
                    angle *= glfwGetTime();
                }
                glDrawArrays(GL_TRIANGLES, 0, 36);

                glm::mat4 model = glm::mat4(1.0f);
                model = glm::translate(model, cubePositions[i]);
                model = glm::rotate(model, glm::radians(angle), glm::vec3(1.0f, 0.3f, 0.5f));
                objectShader.setMat4fv("model", glm::value_ptr(model));
                
                //法线矩阵
                model = glm::inverse(model);    //逆矩阵
                model = glm::transpose(model);  //转置矩阵
                objectShader.setMat4fv("normal", glm::value_ptr(model));
            }

            glm::vec3 cameraPostion = camera.position();
            objectShader.setVec3f("viewPos", cameraPostion);
            objectShader.setFloat("material.shininess", shininess);
            
            // directional light
            directionLight.setDirection(-0.2f, -1.0f, -0.3f);
            directionLight.setAmbient(0.05f, 0.05f, 0.05f);
            directionLight.setDiffuse(1.0f, 0.0f, 0.0f);
            directionLight.setSpecular(0.5f, 0.5f, 0.5f);

            // point light 1
            pointLight1.setPosition(pointLightPositions[0]);
            pointLight1.setAmbient(0.05f, 0.05f, 0.05f);
            pointLight1.setDiffuse(0.0f, 0.0f, 1.0f);
            pointLight1.setSpecular(1.0f, 1.0f, 1.0f);
            
            pointLight1.setConstant(1.0f);
            pointLight1.setLinear(0.09f);
            pointLight1.setQuadratic(0.032);
            
            // point light 2
            pointLight2.setPosition(pointLightPositions[1]);
            pointLight2.setAmbient(0.05f, 0.05f, 0.05f);
            pointLight2.setDiffuse(0.0f, 0.0f, 1.0f);
            pointLight2.setSpecular(1.0f, 1.0f, 1.0f);
            
            pointLight2.setConstant(1.0f);
            pointLight2.setLinear(0.09f);
            pointLight2.setQuadratic(0.032);

            // point light 3
            pointLight3.setPosition(pointLightPositions[2]);
            pointLight3.setAmbient(0.05f, 0.05f, 0.05f);
            pointLight3.setDiffuse(0.0f, 0.0f, 1.0f);
            pointLight3.setSpecular(1.0f, 1.0f, 1.0f);
            
            pointLight3.setConstant(1.0f);
            pointLight3.setLinear(0.09f);
            pointLight3.setQuadratic(0.032);
            // point light 4
            pointLight4.setPosition(pointLightPositions[3]);
            pointLight4.setAmbient(0.05f, 0.05f, 0.05f);
            pointLight4.setDiffuse(0.0f, 0.0f, 1.0f);
            pointLight4.setSpecular(1.0f, 1.0f, 1.0f);
            
            pointLight4.setConstant(1.0f);
            pointLight4.setLinear(0.09f);
            pointLight4.setQuadratic(0.032);
            
            glm::vec3 cameraFront = camera.front();
            // spotLight
            spotlight.setPosition(cameraPostion);
            spotlight.setDirection(cameraFront);
            spotlight.setAmbient(0.0f, 0.0f, 0.0f);
            spotlight.setDiffuse(0.0f, 1.0f, 0.0f);
            spotlight.setSpecular(1.0f, 1.0f, 1.0f);
            
            spotlight.setConstant(1.0f);
            spotlight.setLinear(0.0014f);
            spotlight.setQuadratic(0.000007f);
            
            spotlight.setCutOff(glm::cos(glm::radians(5.5f)));
            spotlight.setOuterCutOff(glm::cos(glm::radians(10.0f)));
            
//            glm::vec3 lightDir = glm::vec3(-0.2f, -1.0f, -0.3f);
//            ourShader.setVec3f("light.direction", glm::value_ptr(lightDir));

//            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
            //第一个参数：指定绘制模式
            //第二个参数：索引的顶点个数
            //第三个参数：索引的类型
            //第四个参数：EBO中的偏移量
            lightShader.use();
            glBindVertexArray(0);
            glBindVertexArray(lightVAO);
            
            lightShader.use();
            glm::vec3 lightColor = glm::vec3(1.0f, 1.0f, 1.0f);
            lightShader.setVec3f("lightColor", lightColor);
            
            lightShader.setMat4fv("view", glm::value_ptr(view));
            lightShader.setMat4fv("projection", glm::value_ptr(projection));
            
            for (unsigned int i = 0; i < 4; i++) {
                
                glm::mat4 model = glm::mat4(1.0f);
                glm::vec3 scale = glm::vec3(0.2f);
                model = glm::translate(model, pointLightPositions[i]);
                model = glm::scale(model, scale);
                lightShader.setMat4fv("model", glm::value_ptr(model));
                
                glDrawArrays(GL_TRIANGLES, 0, 36);
            }
            
            
            //检查有没有什么出发事件（键盘输入，鼠标移动等）
            glfwPollEvents();
            
            //切换双缓冲buffer
            glfwSwapBuffers(window);
        }
        
        glDeleteVertexArrays(1, &VAO);
        glDeleteBuffers(1, &VBO);
        glDeleteBuffers(1, &EBO);
        
//        glDeleteProgram(shaderProgram);
        
        //当渲染循环结束后我们需要正确释放所有资源
        glfwTerminate();
        return 0;
    }
    return 0;
}


