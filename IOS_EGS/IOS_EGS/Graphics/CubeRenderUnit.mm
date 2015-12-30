//
//  CubeRenderUnit.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/30.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "CubeRenderUnit.h"
#import "Mat.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>


@interface CubeRenderUnit()
{
    GLuint _posLocation;
    GLuint _indexLocation;
    GLuint _colorLocation;
    GLuint _modalMatrixLocation;
    GLuint _lookMatrixLocation;
    GLuint _projectionMatrixLocation;
    
    GLuint _vertexBuffer;
    GLuint _colorBuffer;
    GLuint _indexBuffer;

    Mat4 _modolMaxtrix;
    Mat4 _projectionMatrix;
    Mat4 _lookMaxtrix;
}

@end

@implementation CubeRenderUnit

const static char* const s_vertex_cube = SHADER_STRING
(
    uniform mat4 modelMatrix;
    uniform mat4 lookMatrix;
    uniform mat4 proMaxtix;
    attribute vec3 v3Position;
    attribute vec3 av3Color;
    varying vec3 vv3Color;
    void main(void)
    {
        vv3Color = av3Color;
        gl_Position =  proMaxtix *(lookMatrix*modelMatrix)* vec4(v3Position, 1.0);
    }
 );

const static char* const s_fragment_cube = SHADER_STRING_PRECISION_M
(
    varying vec3 vv3Color;
    void main(void)
    {
        gl_FragColor = vec4(vv3Color,1.0);
    }
 
);


-(void)initMatrix
{
    _modolMaxtrix = Mat4::makeIdentity();
    glUniformMatrix4fv(_modalMatrixLocation, 1, GL_FALSE, (GLfloat*)&_modolMaxtrix.data[0][0]);
    
    float w = 4, h = 4;
    _projectionMatrix = Mat4::makePerspective(M_PI/4.0f, w/h, 1, 100);
    _lookMaxtrix = Mat4::makeLookAt(0, 0, 5, 0, 0, 0, 0, 1, 0);
    glUniformMatrix4fv(_projectionMatrixLocation, 1, GL_FALSE, (GLfloat*)&_projectionMatrix.data[0][0]);
    glUniformMatrix4fv(_lookMatrixLocation, 1, GL_FALSE, (GLfloat*)&_lookMaxtrix.data[0][0]);
    
}

-(void)initData
{
     GLfloat vertices[] = {
                            1, 1, 1,  -1, 1, 1,  -1,-1, 1,  1,-1, 1,
                            1, 1, 1,  1,-1, 1,  1,-1,-1,  1, 1,-1,
                            1, 1, 1,  1, 1,-1,  -1, 1,-1,  -1, 1, 1,
                            -1, 1, 1,  -1, 1,-1,  -1,-1,-1,  -1,-1, 1,
                            -1,-1,-1,  1,-1,-1,  1,-1, 1,  -1,-1, 1,
                            1,-1,-1,  -1,-1,-1,  -1, 1,-1,  1, 1,-1
                        };
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_posLocation);
    
    GLfloat color[] =
    {
         1.0, 0.0, 0.0,
         0.0, 0.0, 0.0,
         0.0, 0.0, 1.0,
         1.0, 0.0, 0.0,
         1.0, 0.0, 0.0,
         0.0, 0.0, 0.0,
         0.0, 0.0, 1.0,
         1.0, 0.0, 0.0,
         0.0, 0.0, 0.0,
         0.0, 1.0, 0.0,
         1.0, 0.0, 1.0,
         1.0, 0.0, 0.0,
         1.0, 0.0, 0.0,
         0.0, 1.0, 0.0,
         0.0, 0.0, 1.0,
         1.0, 0.0, 0.0,
         1.0, 0.0, 0.0,
         0.0, 1.0, 0.0,
         0.0, 0.0, 1.0,
         1.0, 0.0, 0.0,
         1.0, 0.0, 0.0,
         0.0, 1.0, 0.0,
         0.0, 0.0, 1.0,
         1.0, 0.0, 0.0,
    };
    glGenBuffers(1, &_colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_colorLocation);
    
    GLushort indexArr[] = {
                        0, 1, 2,  0, 2, 3,
                        4, 5, 6,  4, 6, 7,
                        8, 9,10,  8,10,11,
                        12,13,14,  12,14,15,
                        16,17,18,  16,18,19,
                        20,21,22,  20,22,23
                    };
    
    int triangleIndexCount = sizeof(indexArr)/sizeof(indexArr[0]);
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, triangleIndexCount * sizeof(GLushort), indexArr, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_indexLocation);
}

-(void)startRender
{
    glEnable(GL_DEPTH_TEST);
    
    NSString* vertexString = [NSString stringWithFormat:@"%s", s_vertex_cube];
    NSString* fragmentString = [NSString stringWithFormat:@"%s", s_fragment_cube];
    
    [self initShaderProgram:vertexString
               fragmentCode:fragmentString];
    
    [super startRender];
    
    _posLocation = glGetAttribLocation(self.programUtil.program, "v3Position");
    _colorLocation = glGetAttribLocation(self.programUtil.program, "av3Color");
    _modalMatrixLocation = glGetUniformLocation(self.programUtil.program, "modelMatrix");
    _lookMatrixLocation = glGetUniformLocation(self.programUtil.program, "lookMatrix");
    _projectionMatrixLocation = glGetUniformLocation(self.programUtil.program, "proMaxtix");
    
    [self initMatrix];
    [self initData];
    [self handlePos:300 newY:200];
}

-(void)handlePos : (CGFloat)newX newY : (CGFloat)newY
{
    CGFloat dx = newX - self.lastPoint.x;
    
    Mat4 newRotateMatrix = Mat4::makeIdentity();
    newRotateMatrix.rotate(dx / 5.0 * M_PI / 180.0, 0, 1, 0);
    
    CGFloat dy = newY - self.lastPoint.y;
    newRotateMatrix.rotate(dy / 5.0 * M_PI / 180.0, 1, 0, 0);
    _modolMaxtrix = newRotateMatrix * _modolMaxtrix;
    
    self.lastPoint = CGPointMake(newX, newY);
}

-(void)renderToScene
{
    
    [super renderToScene];
    
    glUniformMatrix4fv(_modalMatrixLocation, 1, GL_FALSE, (GLfloat*)&_modolMaxtrix.data[0][0]);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glEnableVertexAttribArray(_posLocation);
    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, false, 0, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glEnableVertexAttribArray(_colorLocation);
    glVertexAttribPointer(_colorLocation, 3, GL_FLOAT, false, 0, 0);
    
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_SHORT, 0);
}

-(void)beginTouch:(CGFloat)x Y:(CGFloat)y
{
    [super beginTouch:x Y:y];
}

-(void)touchMoving:(CGFloat)x Y:(CGFloat)y
{
    [self handlePos:x newY:y];
    
//    [self renderToScene];
}

-(void)dealloc
{
    glDeleteBuffers(1, &_colorBuffer);
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
}

@end
