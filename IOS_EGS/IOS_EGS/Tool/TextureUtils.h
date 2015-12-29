//
//  TextureUtils.h
//  IOS_EGS
//
//  Created by ixshells on 15/12/29.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#ifndef TextureUtils_h
#define TextureUtils_h

@interface Texture2D : NSObject

@property(nonatomic, assign)GLuint textureId;

-(instancetype)initWithImageData:(NSData *)data size : (CGSize)imageSize channel:(GLint)channel;

-(void)bindToIndex : (GLuint)index;

-(void)releaseTexture;

@end


@interface TextureUtils : NSObject

@property(nonatomic, readonly)CGSize imageSize;
@property(nonatomic, readonly)NSData*  imageData;

- (void)loadImageData:(UIImage *)image comlete : (void (^)(NSData *))comlete;
-(void)releaseTextureUtils;

@end

#endif /* TextureUtils_h */
