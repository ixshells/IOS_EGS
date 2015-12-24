//
//  RenderInterface.h
//  IOS_EGS
//
//  Created by ixshells on 15/12/24.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#ifndef RenderInterface_h
#define RenderInterface_h

@protocol RenderInterface <NSObject>

@required
-(void)startRender;

-(void)renderToScene;

-(void)releaseProgram;

@end


#endif /* RenderInterface_h */
