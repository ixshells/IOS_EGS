//
//  TexCubeRenderUnit.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/31.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "TexCubeRenderUnit.h"
#import "Mat.h"
#import "TextureUtils.h"


@interface TexCubeRenderUnit()
{
    GLuint _posLocation;
    GLuint _indexLocation;
    GLuint _texCoodLocation;
    GLuint _modalMatrixLocation;
    GLuint _lookMatrixLocation;
    GLuint _projectionMatrixLocation;
    GLuint _textureLocation;
    
    GLuint _vertexBuffer;
    GLuint _texCoodBuffer;
    GLuint _indexBuffer;
    
    Mat4 _modolMaxtrix;
    Mat4 _projectionMatrix;
    Mat4 _lookMaxtrix;
    
    TextureUtils* _textureUtil;
    Texture2D* _texture2d;
}

@end

@implementation TexCubeRenderUnit

const static char* const s_vertex_cube = SHADER_STRING
(
 uniform mat4 modelMatrix;
 uniform mat4 lookMatrix;
 uniform mat4 proMaxtix;
 attribute vec3 v3Position;
 attribute vec2 texCood;
 varying vec2 vTexCood;
 void main(void)
 {
     vTexCood = vec2((texCood.x+1.0)/2.0, 1.0-(texCood.y+1.0)/2.0);
     gl_Position =  proMaxtix *(lookMatrix*modelMatrix)* vec4(v3Position, 1.0);
 }
 );

const static char* const s_fragment_cube = SHADER_STRING_PRECISION_M
(
 uniform sampler2D sTexture;
varying vec2 vTexCood;
 void main(void)
 {
     vec3 src = texture2D(sTexture, vTexCood).rgb;
     gl_FragColor = vec4(src, 1.0);
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
    
    GLfloat texCood[] =
    {
        1, 1,  -1, 1,  -1,-1,  1,-1,
        1, 1,  -1, 1,  -1,-1,  1,-1,
        1, 1,  1, -1,  -1, -1,  -1, 1,
        1, 1,  1,-1,  -1,-1,  -1, 1,
        -1,-1,  1,-1,  1, 1,  -1, 1,
        1,-1,  -1,-1,  -1, 1,  1, 1
    };
    glGenBuffers(1, &_texCoodBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoodBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(texCood), texCood, GL_STATIC_DRAW);
    glEnableVertexAttribArray(_texCoodLocation);
    
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
    _texCoodLocation = glGetAttribLocation(self.programUtil.program, "texCood");
    _modalMatrixLocation = glGetUniformLocation(self.programUtil.program, "modelMatrix");
    _lookMatrixLocation = glGetUniformLocation(self.programUtil.program, "lookMatrix");
    _projectionMatrixLocation = glGetUniformLocation(self.programUtil.program, "proMaxtix");
    _textureLocation = glGetUniformLocation(self.programUtil.program, "sTexture");
    
    _textureUtil = [[TextureUtils alloc] init];
    __weak typeof(self) weakSelf = self;
    [_textureUtil loadImageData:[UIImage imageNamed:@"wooden.png"] comlete:^(NSData *datas) {
        [weakSelf loadCompleteHandle:datas];
    }];
    
    [self initMatrix];
    [self initData];
    [self handlePos:300 newY:200];
}

-(void)loadCompleteHandle : (NSData *)data
{
    if(nil != data && nil == _texture2d)
    {
        _texture2d = [[Texture2D alloc] initWithImageData:_textureUtil.imageData size:_textureUtil.imageSize channel:4];
    }
}

-(void)handlePos : (CGFloat)newX newY : (CGFloat)newY
{
    CGFloat dx = newX - self.lastPoint.x;
    
    Mat4 newRotateMatrix = Mat4::makeIdentity();
    newRotateMatrix.rotate(dx / 2.0 * M_PI / 180.0, 0, 1, 0);
    
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
    
    glBindBuffer(GL_ARRAY_BUFFER, _texCoodBuffer);
    glEnableVertexAttribArray(_texCoodLocation);
    glVertexAttribPointer(_texCoodLocation, 2, GL_FLOAT, false, 0, 0);
    if(nil != _texture2d)
    {
        [_texture2d bindToIndex:0];
        glUniform1i(_textureLocation, 0);
    }
    
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
    glDeleteBuffers(1, &_texCoodBuffer);
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
}

@end
