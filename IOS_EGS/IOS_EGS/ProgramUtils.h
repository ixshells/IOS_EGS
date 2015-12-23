//
//  ProgramUtils.h
//  IOS_EGS
//
//  Created by ixshells on 15/12/23.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#ifndef ProgramUtils_h
#define ProgramUtils_h


@interface ShaderCodeUtil : NSObject

@property(nonatomic, assign)GLenum shaderType;
@property(nonatomic, strong)NSString* shaderCode;
@property(nonatomic, assign)GLuint  shader;

-(instancetype)initWithShaderCode : (NSString *)shaderCode type : (GLenum)shaderType;
-(instancetype)initWithShaderFilePath : (NSString *)filepath type : (GLenum)shaderType;

+(NSString *)loadShaderFromFile:(NSString *)filepath;

-(void)releaseShader;

@end

@interface ProgramUtil : NSObject

@property(nonatomic, assign)GLuint  program;
@property(nonatomic, strong)ShaderCodeUtil* vertexShader;
@property(nonatomic, strong)ShaderCodeUtil* fragmentShader;

-(instancetype)initWithCode : (NSString *)vertexCode fragmentCode : (NSString *)fragmentCode;
-(instancetype)initWithShaderPath : (NSString *)vertexFilePath fragmentFilePath : (NSString *)fragmentFilePath;

-(BOOL)link;

-(void)releaseProgram;

@end

#endif /* ProgramUtils_h */
