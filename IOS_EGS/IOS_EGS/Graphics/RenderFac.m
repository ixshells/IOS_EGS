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
#import "ColorTriangleRenderUnit.h"
#import "TexTriangleRenderUnit.h"
#import "Rot_Trans_ScaleRenderUnit.h"


@interface RenderFac()
{
    RenderUnitType  _renderUnitType;
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
    if(type == _renderUnitType)
        return;
    
    _renderUnitType = type;
    switch (type) {
        case TriangleRenderUnitType:
            _renderUnit = [[TriangleRenderUnit alloc] init];
            break;
        case ColorTriangleRenderUnitType:
            _renderUnit = [[ColorTriangleRenderUnit alloc] init];
            break;
        case TexTriangleRenderUnitType:
            _renderUnit = [[TexTriangleRenderUnit alloc] init];
            break;
        case RotTransScaleRenderUnitType:
            _renderUnit = [[Rot_Trans_ScaleRenderUnit alloc] init];
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