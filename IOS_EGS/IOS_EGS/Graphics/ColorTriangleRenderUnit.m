//
//  ColorTriangleRenderUnit.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/25.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "ColorTriangleRenderUnit.h"

@interface ColorTriangleRenderUnit()
{
    GLuint _posLocation;
    GLuint _colorLocation;
}

@end

@implementation ColorTriangleRenderUnit


-(void)startRender
{
    [self initShaderProgram:@"attribute vec3 v3Position;attribute vec3 av3Color;varying vec3 vv3Color;void main(void){vv3Color = av3Color;gl_Position = vec4(v3Position, 1.0);}"
               fragmentCode:@"precision mediump float;varying vec3 vv3Color;void main(void){gl_FragColor = vec4(vv3Color,1.0);}"];
    
    [super startRender];
    
    _posLocation = glGetAttribLocation(self.programUtil.program, "v3Position");
    _colorLocation = glGetAttribLocation(self.programUtil.program, "av3Color");
}

-(void)renderToScene
{
    GLfloat vertices[] = {
        0.0, 1.0, 0.0,
        -1.0, 0.0, 0.0,
        1.0, 0.0, 0.0
    };
    
    GLfloat color[] = {
        0.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
        1.0, 0.0, 0.0
    };
    
    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_posLocation);
    
    glVertexAttribPointer(_colorLocation, 3, GL_FLOAT, GL_FALSE, 0, color);
    glEnableVertexAttribArray(_colorLocation);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}


@end
