//
//  TextureUtils.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/29.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "TextureUtils.h"

@interface Texture2D()
{
    
}

@end

@implementation Texture2D

-(instancetype)initWithImageData:(NSData *)data size : (CGSize)imageSize channel:(GLint)channel
{
    self = [super init];
    
    
    if(nil != self)
    {
        _textureId = [self textureWithImageData:data size:imageSize channel:channel];
    }
    
    return self;
}

-(GLuint)textureWithImageData : (NSData *)data size : (CGSize)imageSize channel:(GLint)channel
{
    
    glActiveTexture(GL_TEXTURE0 );
    GLuint textureHandle = 0;
    
    glGenTextures(1, &textureHandle);
    glBindTexture(GL_TEXTURE_2D, textureHandle);
    
    glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
     glEnable(GL_TEXTURE_2D);
    
    void* pixels = (void *)[data bytes];
    CGSize size = imageSize;
    
    GLenum format;
    static GLenum eArr[] = { GL_LUMINANCE, GL_LUMINANCE_ALPHA, GL_RGB, GL_RGBA};
    format = eArr[channel - 1];

    
    glTexImage2D(GL_TEXTURE_2D, 0, format, size.width, size.height, 0, format, GL_UNSIGNED_BYTE, pixels);
    
    glGenerateMipmap(GL_TEXTURE_2D);
    
    return textureHandle;
}

-(void)bindToIndex : (GLuint)index
{
    glActiveTexture(GL_TEXTURE0 + index);
    glBindTexture(GL_TEXTURE_2D, _textureId);
}

-(void)releaseTexture
{
    if(0 != _textureId)
    {
        glDeleteTextures(1, &(_textureId));
        _textureId = 0;
    }
}


@end


@interface TextureUtils()
{
    
}

@end


@implementation TextureUtils

- (void)loadImageData:(UIImage *)image comlete : (void (^)(NSData *))comlete
{
    _imageData = nil;
    CGImageRef cgImage = image.CGImage;
    
    _imageSize.width = CGImageGetWidth(cgImage);
    _imageSize.height = CGImageGetHeight(cgImage);

    int bpp = 4;
    int byteCount = _imageSize.width * _imageSize.height * bpp;
    unsigned char* data = (unsigned char*) calloc(byteCount, 1);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(data,
                                                 _imageSize.width,
                                                 _imageSize.height,
                                                 8,
                                                 bpp * _imageSize.width,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGRect rect = CGRectMake(0, 0, _imageSize.width, _imageSize.height);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRelease(context);
    
    _imageData = ([NSData dataWithBytesNoCopy:data length:byteCount freeWhenDone:YES]);
    
    comlete(_imageData);
    
}

-(void)releaseTextureUtils
{
    _imageSize = CGSizeZero;
    _imageData = nil;
}

@end
