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

-(void)startRender;

-(void)renderToScene;

-(void)releaseProgram;

@end




#endif /* BaseRender_h */
