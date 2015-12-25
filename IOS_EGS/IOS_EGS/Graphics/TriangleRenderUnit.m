//
//  TriangleRenderUnit.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/24.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "TriangleRenderUnit.h"

@interface TriangleRenderUnit()
{
     GLuint _posLocation;
}

@end

@implementation TriangleRenderUnit

-(void)startRender
{
    [self initShaderProgram:@"attribute vec3 v3Position;void main(void){gl_Position = vec4(v3Position, 1.0);}"
               fragmentCode:@"void main(void){gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);}"];
    
    [super startRender];
    _posLocation = glGetAttribLocation(self.programUtil.program, "v3Position");
}

-(void)renderToScene
{
    GLfloat vertices[] = {
        0.0, 1.0, 0.0,
        -1.0, 0.0, 0.0,
        1.0, 0.0, 0.0
    };
    
    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_posLocation);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}



@end