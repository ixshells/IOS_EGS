//
//  GLViewController.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/22.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "GLViewController.h"

@interface GLViewController()<GLKViewDelegate>
{
    
}

@property(nonatomic, strong)EAGLContext* context;
@end

@implementation GLViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"EGS DEMO";
    
    self.view.backgroundColor = [UIColor cyanColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //init context
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    glViewport(50, 50, 100, 100);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

@end