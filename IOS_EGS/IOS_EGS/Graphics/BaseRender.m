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

-(ProgramUtil *)programUtil
{
    if(nil == _programUtil)
    {
        _programUtil = [[ProgramUtil alloc] initWithCode:@"attribute vec3 v3Position;void main(void){gl_Position = vec4(v3Position, 1.0);}"
                                            fragmentCode:@"void main(void){gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);}"];
    }
    return _programUtil;
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

@end
