//
//  BaseRender.h
//  IOS_EGS
//
//  Created by ixshells on 15/12/24.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#ifndef BaseRender_h
#define BaseRender_h

#import "RenderInterface.h"
#import "ProgramUtils.h"

@interface BaseRender : NSObject<RenderInterface>

@property(nonatomic, strong)ProgramUtil* programUtil;
@property(nonatomic, assign)CGPoint lastPoint;

-(void)initShaderProgram : (NSString *)vertexCode fragmentCode : (NSString *)fragmentCode;

-(void)startRender;

-(void)renderToScene;

-(void)beginTouch : (CGFloat)x Y : (CGFloat)y;

-(void)touchMoving : (CGFloat)x Y:(CGFloat)y;

-(void)releaseProgram;

@end




#endif /* BaseRender_h */
