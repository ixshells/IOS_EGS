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
