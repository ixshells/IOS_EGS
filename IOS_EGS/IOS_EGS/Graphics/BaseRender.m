//
//  BaseRender.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/24.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "BaseRender.h"

@interface BaseRender()
{
    
}

@end

@implementation BaseRender


#pragma mark RenderInterface


-(void)initShaderProgram : (NSString *)vertexCode fragmentCode : (NSString *)fragmentCode
{
    if(nil == _programUtil)
    {
        _programUtil = [[ProgramUtil alloc] initWithCode:vertexCode fragmentCode:fragmentCode];
    }
}

-(void)startRender
{
    glUseProgram(self.programUtil.program);
}

-(void)renderToScene
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

-(void)beginTouch : (CGFloat)x Y : (CGFloat)y
{
    _lastPoint = CGPointMake(x, y);
}

-(void)touchMoving:(CGFloat)x Y:(CGFloat)y
{

}

-(void)releaseProgram
{
    [self.programUtil releaseProgram];
}

-(void)dealloc
{
    [self releaseProgram];
}

@end
