//
//  TexTriangleRenderUnit.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/29.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "TexTriangleRenderUnit.h"
#import "TextureUtils.h"


@interface TexTriangleRenderUnit()
{
    GLuint _posLocation;
    GLuint _textureLocation;
    TextureUtils* _textureUtil;
    Texture2D* _texture2d;
}

@end

@implementation TexTriangleRenderUnit

const static char* const s_vertex_textriangle = SHADER_STRING(
      attribute vec3 v3Position;
      varying vec2 vTexCood;
      void main()
      {
          vTexCood = vec2((v3Position.x+1.0)/2.0, 1.0-(v3Position.y+1.0)/2.0);
          gl_Position = vec4(v3Position, 1.0);
      }
);

const static char* const s_texTriangle = SHADER_STRING_PRECISION_M
(
     varying vec2 vTexCood;
     uniform sampler2D sTexture;
     void main()
     {
         vec3 src = texture2D(sTexture, vTexCood).rgb;
         gl_FragColor = vec4(src, 1.0);
     }

 );

-(void)startRender
{

    NSString* vertexString = [NSString stringWithFormat:@"%s", s_vertex_textriangle];
    NSString* fragmentString = [NSString stringWithFormat:@"%s", s_texTriangle];
    
    [self initShaderProgram:vertexString
               fragmentCode:fragmentString];
    
    [super startRender];
    
    _posLocation = glGetAttribLocation(self.programUtil.program, "v3Position");
    _textureLocation = glGetUniformLocation(self.programUtil.program, "sTexture");
    
    _textureUtil = [[TextureUtils alloc] init];
    __weak typeof(self) weakSelf = self;
    [_textureUtil loadImageData:[UIImage imageNamed:@"wooden.png"] comlete:^(NSData *datas) {
        [weakSelf loadCompleteHandle:datas];
    }];
}

-(void)loadCompleteHandle : (NSData *)data
{
    if(nil != data && nil == _texture2d)
    {
        _texture2d = [[Texture2D alloc] initWithImageData:_textureUtil.imageData size:_textureUtil.imageSize channel:4];
    }
}

-(void)renderToScene
{
    GLfloat vertices[] = {
        0.0, 1.0, 0.0,
        -1.0, 0.0, 0.0,
        1.0, 0.0, 0.0
    };
    
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_posLocation);
    
    if(nil != _texture2d)
    {
        [_texture2d bindToIndex:0];
        glUniform1i(_textureLocation, 0);
    }
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

-(void)dealloc
{
    if(nil != _texture2d)
    {
        [_texture2d releaseTexture];
    }
    
    if(nil != _textureUtil)
    {
        [_textureUtil releaseTextureUtils];
    }
}

@end
