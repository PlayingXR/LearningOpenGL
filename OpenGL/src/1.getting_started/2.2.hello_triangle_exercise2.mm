//
//  main.m
//  OpenGL
//
//  Created by wxh on 2018/11/27.
//  Copyright © 2018 wxh. All rights reserved.
//

#include <glad/glad.h>
#include "GLFW/glfw3.h"
#include <iostream>

bool isLineModel = false;

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
}

float vertices1[] = {
    -0.5f, 0.0f, 0.0f,
    0.0f, 0.0f, 0.0f,
    -0.25f, 0.5f, 0.0f
};
float vertices2[] = {
    0.0f, 0.0f, 0.0f,
    0.5f, 0.0f, 0.0f,
    0.25f, 0.5f, 0.0f
};
unsigned int indices1[] = {
    0, 1, 2
};
unsigned int indices2[] = {
    0, 1, 2
};

const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

const char *vertexShaderSource = "#version 330 core\n"
"layout (location = 0) in vec3 aPos;\n"
"void main()\n"
"{\n"
"   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
"}\0";
const char *fragmentShaderSource = "#version 330 core\n"
"out vec4 FragColor;\n"
"void main()\n"
"{\n"
"   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
"}\n\0";



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
        
        //在调用任何OpenGL的函数之前我们需要初始化GLAD
        if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
            std::cout << "Faild to initialize GLAD" << std::endl;
            return -1;
        }
        
        glViewport(0, 0, SCR_WIDTH, SCR_HEIGHT);
        glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
        
        //vertex shader
        unsigned int vertexShader;
        vertexShader = glCreateShader(GL_VERTEX_SHADER);
        //使用glCreateShader来创建着色器，参数是类型，GL_VERTEX_SHADER表示是顶点着色器
        glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
        //用glShaderSource函数来编译着色器
        //第一个参数是着色器对象，
        //第二个参数是源码字符串的数量
        //第三个参数是源码
        //第四个。。。
        glCompileShader(vertexShader);
        
        //检查是否编译成功
        int success;
        char infoLog[512];
        glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
            std::cout << "ERROR::COMPILE VERTEX SHADER";
        }
        
        unsigned int fragmentShader;
        fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
        glCompileShader(fragmentShader);
        
        glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
        if (!success) {
            glad_glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
            std::cout << "ERROR::COMPILE FRAGMENT SHADER";
        }
        
        unsigned int shaderProgram;
        shaderProgram = glCreateProgram();
        glAttachShader(shaderProgram, vertexShader);
        glAttachShader(shaderProgram, fragmentShader);
        glLinkProgram(shaderProgram);
        //把顶点着色器和片段着色器装载到着色器程序上
        //使用glLinkProgram进行链接
        
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        //手动释放不需要的资源
        
        //创建VAO
        unsigned int VAOs[2], VBOs[2], EBOs[2];
        glGenVertexArrays(2, VAOs);
        glGenBuffers(2, VBOs);
        glGenBuffers(2, EBOs);
        
        //绑定VAO
        glBindVertexArray(VAOs[0]);
        
        //生成buffer来存顶点，叫VBO
        //把VBO绑定到GL_ARRAY_BUFFER目标上
        glBindBuffer(GL_ARRAY_BUFFER, VBOs[0]);
        //这样只需要我们往GL_ARRAY_BUFFER目标上写入数据都会缓冲到VBO上
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices1), vertices1, GL_STATIC_DRAW);
        
        //绑定EBO
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBOs[0]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices1), indices1, GL_STATIC_DRAW);
        
        //glBufferData是一个专门把用户定义的数据复制到当前绑定的缓冲的buffer里
        //第一个参数是目标缓冲的类型
        //第二个参数指定传输数据的大小（以字节为单位）sizof可以计算出顶点数据的大小
        //第三个参数是我们发出数据
        //第四个参数是指定显卡如何管理这些数据，它有三种形式：
        //GL_STATIC_DRAW：数据不会或几乎不会改变
        //GL_DYNAMIC_DRAW：数据会改改变很多次
        //GL_STREAM_DRAW：数据每次绘制都会改变
        
        //设置顶点属性指针
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
        //第一个参数：顶点属性，与vertex shader中的location = 0对应
        //第二个参数：每一个顶点属性的分量个数
        //第三个参数：每个分量的类型
        //第四个参数：是否希望s数据被标准化，即映射到0到1之间
        //第五个参数：步长，即每个顶点属性的size
        //第六个参数：位置数据在缓冲中起始位置的偏移量
        glEnableVertexAttribArray(0);
        glBindVertexArray(0);
        
        glBindVertexArray(VBOs[1]);
        glBindBuffer(GL_ARRAY_BUFFER, VBOs[1]);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBOs[1]);
        
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices2), vertices2, GL_STATIC_DRAW);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices2), indices2, GL_STATIC_DRAW);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
        glEnableVertexAttribArray(0);
        glBindVertexArray(0);
        
        //使用while循环来不断的渲染画面，我们称之为渲染循环（Render Loop）
        //没次循环开始之前检查一次GLFW是否被要求退出
        while (!glfwWindowShouldClose(window)) {
            //输入
            processInput(window);
            
            //渲染指令
            //glClearColor是一个状态设置函数，清除屏幕颜色为（0.2，0.3，0.3，1.0）
            glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
            
            //glClear是一个状态使用函数，清除深度缓冲
            glClear(GL_COLOR_BUFFER_BIT);
            
            glUseProgram(shaderProgram);
            //使用指定的着色器，在后面的每个着色器调用和渲染调用都会使用这个着色程序
               
            glBindVertexArray(VAOs[0]);
            
//            glDrawArrays(GL_TRIANGLES, 0, 3);
            //第一个参数：绘制图元
            //第二个参数：顶点数组的其实索引
            //第三个参数：需要绘制的顶点个数

            glDrawElements(GL_TRIANGLES, 3*1, GL_UNSIGNED_INT, 0);
            //第一个参数：指定绘制模式
            //第二个参数：索引的顶点个数
            //第三个参数：索引的类型
            //第四个参数：EBO中的偏移量
            
            glBindVertexArray(0);
            
            glBindVertexArray(VAOs[1]);
            glDrawElements(GL_TRIANGLES, 3*1, GL_UNSIGNED_INT, 0);
            glBindVertexArray(0);
            
            //检查有没有什么出发事件（键盘输入，鼠标移动等）
            glfwPollEvents();
            
            //切换双缓冲buffer
            glfwSwapBuffers(window);
        }
        
        glDeleteVertexArrays(2, VAOs);
        glDeleteBuffers(2, VBOs);
        glDeleteBuffers(2, EBOs);
        
        //当渲染循环结束后我们需要正确释放所有资源
        glfwTerminate();
        return 0;
    }
    return 0;
}


