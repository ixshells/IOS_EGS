//
//  GLViewController.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/22.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "GLViewController.h"
#import "ProgramUtils.h"

@interface GLViewController()<GLKViewDelegate>
{
    GLuint _posLocation;
}

@property(nonatomic, strong)EAGLContext* context;
@property(nonatomic, strong)ProgramUtil* programUtil;

@end

@implementation GLViewController


-(ProgramUtil *)programUtil
{
    if(nil == _programUtil)
    {
        _programUtil = [[ProgramUtil alloc] initWithCode:@"attribute vec3 v3Position;void main(void){gl_Position = vec4(v3Position, 1.0);}"
                                        fragmentCode:@"void main(void){gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);}"];
    }
    return _programUtil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"EGS DEMO";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    //init context
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    glViewport(0, 0, fSelfViewWidth, fSelfViewHeight);
    
    glUseProgram(self.programUtil.program);
    
    _posLocation = glGetAttribLocation(self.programUtil.program, "v3Position");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLfloat vertices[] = {
        0.0, 1.0, 0.0,
        -1.0, 0.0, 0.0,
        1.0, 0.0, 0.0
    };

    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_posLocation);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

-(void)dealloc
{
    [self.programUtil releaseProgram];
}

@end