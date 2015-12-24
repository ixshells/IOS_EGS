//
//  RenderFac.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/24.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "RenderFac.h"
#import "RenderInterface.h"
#import "TriangleRenderUnit.h"


@interface RenderFac()
{
    
}


@property(nonatomic, strong)id<RenderInterface>  renderUnit;
@end

@implementation RenderFac


+(instancetype)shareInstance
{
    
    static RenderFac* s_defaultManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_defaultManager = [[self alloc] init];
    });
    
    return s_defaultManager;
}


-(void)initRenderUnit:(RenderUnitType)type
{
    switch (type) {
        case TriangleRenderUnitType:
            _renderUnit = [[TriangleRenderUnit alloc] init];
            break;
            
        default:
            break;
    }
}

-(void)startRender
{
    [self.renderUnit startRender];
}

-(void)renderToScene
{
    [self.renderUnit renderToScene];
}

@end