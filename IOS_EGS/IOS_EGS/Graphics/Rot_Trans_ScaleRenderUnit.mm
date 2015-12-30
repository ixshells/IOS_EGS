//
//  Rot_Trans_ScaleRenderUnit.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/30.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "Rot_Trans_ScaleRenderUnit.h"
#import "Mat.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>


@interface Rot_Trans_ScaleRenderUnit()
{
    GLuint _posLocation;
    GLuint _colorLocation;
    GLuint _matrixLocation;
    
    int  _angle;
    float  _translate;
    float  _scale;
}

@end

@implementation Rot_Trans_ScaleRenderUnit

const static char* const s_vertex_rotTranScale = SHADER_STRING
(
 attribute vec3 v3Position;
 uniform mat4 um4Matrix;
 attribute vec3 av3Color;
 varying vec3 vv3Color;
 void main(void)
 {
     vec4 v4pos = um4Matrix * vec4(v3Position, 1.0);
     vv3Color = av3Color;
     gl_Position = v4pos;
 }
);

const static char* const s_fragment_rotTranScale = SHADER_STRING_PRECISION_M
(
 varying vec3 vv3Color;

 void main(void)
 {
     
     gl_FragColor = vec4(vv3Color, 1.0);
 }
 
);

-(void)startRender
{
    NSString* vertexString = [NSString stringWithFormat:@"%s", s_vertex_rotTranScale];
    NSString* fragmentString = [NSString stringWithFormat:@"%s", s_fragment_rotTranScale];
    
    [self initShaderProgram:vertexString
               fragmentCode:fragmentString];
    
    [super startRender];
    
    _posLocation = glGetAttribLocation(self.programUtil.program, "v3Position");
    _colorLocation = glGetAttribLocation(self.programUtil.program, "av3Color");
    _matrixLocation = glGetUniformLocation(self.programUtil.program, "um4Matrix");
    
    _angle = 0;
    _translate = -1;
}


-(void)updateData
{
    _angle += 10;
    _angle %= 360;
    
    _translate  <= 1.0 ? _translate += 0.025 : _translate = -1;
    _scale >= 0.0 ? _scale -= 0.01 : _scale = 0.5;
}

-(void)renderToScene
{
    [self updateData];
    
    GLfloat vertices[] = {
        0.0, 1.0, 0.0,
        -1.0, 0.0, 0.0,
        1.0, 0.0, 0.0
    };
    
    GLfloat color[] = {
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
    };
    
    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_posLocation);
    
    glVertexAttribPointer(_colorLocation, 3, GL_FLOAT, GL_FALSE, 0, color);
    glEnableVertexAttribArray(_colorLocation);
    
    Mat4 mat4 = Mat4::makeIdentity();
    mat4.scale(0.5, 0.5, 1.0);
    mat4.rotateZ(M_PI/180.0*_angle);
    glUniformMatrix4fv(_matrixLocation, 1, GL_FALSE, (GLfloat*)&mat4.data[0][0]);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    Mat4 translate = Mat4::makeIdentity();
    translate.translate(_translate, _translate, 0.0);
    translate.scale(0.5, 0.5, 1.0);
    glUniformMatrix4fv(_matrixLocation, 1, GL_FALSE, (GLfloat*)&translate.data[0][0]);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    Mat4 scale = Mat4::makeIdentity();
    scale.translate(-0.5, 0.5, 0.0);
    scale.scale(_scale, _scale, 0.0);
    glUniformMatrix4fv(_matrixLocation, 1, GL_FALSE, (GLfloat*)&scale.data[0][0]);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}


@end