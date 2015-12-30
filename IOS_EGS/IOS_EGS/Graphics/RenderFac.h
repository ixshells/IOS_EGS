//
//  RenderFac.h
//  IOS_EGS
//
//  Created by ixshells on 15/12/24.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#ifndef RenderFac_h
#define RenderFac_h

typedef NS_OPTIONS(NSUInteger, RenderUnitType) {
    TriangleRenderUnitType                  = 1,
    ColorTriangleRenderUnitType             = 2,
    TexTriangleRenderUnitType               = 3,
    RotTransScaleRenderUnitType             = 4,
    CubeRenderUnitType                      = 5,
};

@interface RenderFac : NSObject

+(instancetype)shareInstance;

-(void)initRenderUnit : (RenderUnitType)type;

-(void)startRender;

-(void)renderToScene;

-(void)beginTouch : (CGFloat)x Y : (CGFloat)y;

-(void)touchMoving : (CGFloat)x Y:(CGFloat)y;

@end

#endif /* RenderFac_h */
