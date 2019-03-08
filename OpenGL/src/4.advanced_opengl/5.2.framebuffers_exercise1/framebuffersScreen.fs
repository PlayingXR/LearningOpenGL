#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D screenTexture;

const float offset = 1.0 / 300.0;

float luminance(vec3 color) {
    return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
}

void main()
{
    vec3 color = texture(screenTexture, TexCoords).rgb;
    FragColor = vec4(color, 1.0);
    
    //1、反相
//    vec3 color = texture(screenTexture, TexCoords).rgb;
//    color = 1.0 - color;
//    FragColor = vec4(color, 1.0);
    
    //2、灰度
//    vec3 color = texture(screenTexture, TexCoords).rgb;
//    float average = (color.r + color.g + color.b) / 3.0;
//    FragColor = vec4(vec3(average), 1.0);
    
    //灰度加权：人眼对绿色更加敏感，对蓝色不那么敏感
//    vec3 color = texture(screenTexture, TexCoords).rgb;
//    float average = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
//    FragColor = vec4(vec3(average), 1.0);
    
    //3、锐化核
//    float kernel[9] = float[](-1,   -1, -1,
//                              -1,   9,  -1,
//                              -1,   -1, -1);
    
    //4、模糊核
//    float kernel[9] = float[](1.0 / 16,   2.0 / 16, 1.0 / 16,
//                              2.0 / 16,   4.0 / 16, 2.0 / 16,
//                              1.0 / 16,   2.0 / 16, 1.0 / 16);
    
//    5、边缘检测
//    float kernel[9] = float[](1.0,   1.0, 1.0,
//                              1.0,   -8.0, 1.0,
//                              1.0,   1.0, 1.0);

//    vec2 offsets[9] = vec2[](vec2(-offset,  offset),    //左上
//                             vec2(0.0f,     offset),    //正上
//                             vec2(offset,   offset),    //右上
//
//                             vec2(-offset,  0.0f),      //左
//                             vec2(0.0f,     0.0f),      //中
//                             vec2(offset,   0.0f),      //右
//
//                             vec2(-offset,  -offset),   //左下
//                             vec2(0.0f,     -offset),   //正下
//                             vec2(offset,   -offset));  //右下
//
//    vec3 sampleTex[9];
//    for (int i = 0; i < 9; ++i) {
//        sampleTex[i] = vec3(texture(screenTexture, TexCoords.st + offsets[i]));
//    }
//    vec3 color = vec3(0.0);
//    for (int i = 0; i < 9; ++i) {
//        color += sampleTex[i] * kernel[i];
//    }
//
//    FragColor = vec4(color, 1.0);
    
//    6、使用梯度值计算边缘检测
//    vec2 offsets[9] = vec2[](vec2(-offset,  offset),    //左上
//                             vec2(0.0f,     offset),    //正上
//                             vec2(offset,   offset),    //右上
//
//                             vec2(-offset,  0.0f),      //左
//                             vec2(0.0f,     0.0f),      //中
//                             vec2(offset,   0.0f),      //右
//
//                             vec2(-offset,  -offset),   //左下
//                             vec2(0.0f,     -offset),   //正下
//                             vec2(offset,   -offset));  //右下
//
//    float Gx[9] = float[](-1.0, -2.0,   -1.0,
//                          0.0,  0.0,    0.0,
//                          1.0,  2.0,    1.0);
//
//    float Gy[9] = float[](-1.0, 0.0, 1.0,
//                          -2.0, 0.0, 2.0,
//                          -1.0, 0.0, 1.0);
//
//    float texColor;
//    float edgeX = 0;
//    float edgeY = 0;
//    for (int i = 0; i < 9; ++i) {
//        vec3 color = texture(screenTexture, TexCoords.st + offsets[i]).rgb;
//        texColor = luminance(color);
//        edgeX += texColor * Gx[i];
//        edgeY += texColor * Gy[i];
//    }
//    float edge = 1 - abs(edgeX) - abs(edgeY);
//
//    vec4 edgeColor = vec4(1.0, 1.0, 1.0, 1.0);
//    vec4 backgroundColor = vec4(0.0, 0.0, 0.0, 1.0);
//
//    vec4 withEdgeColor = mix(edgeColor, texture(screenTexture, TexCoords.st), edge);
//////    vec4 onlyEdgeColor = lerp(edgeColor, backgroundColor, edge);
//    FragColor = withEdgeColor;
}
