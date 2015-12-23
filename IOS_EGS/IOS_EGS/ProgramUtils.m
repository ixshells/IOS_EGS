//
//  ProgramUtils.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/23.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "ProgramUtils.h"

@implementation ShaderCodeUtil

-(instancetype)initWithShaderCode : (NSString *)shaderCode type : (GLenum)shaderType
{
    self = [super init];
    
    if(nil != self)
    {
        self.shaderCode = shaderCode;
        self.shaderType = shaderType;
        self.shader = glCreateShader(shaderType);
        if (0 == self.shader) {
            NSLog(@"Error: failed to create shader.");
            return nil;
        }
        
        if(nil != shaderCode)
        {
            if(![self loadShader:shaderCode])
                return nil;
        }
    }
    
    return self;
}

-(instancetype)initWithShaderFilePath : (NSString *)filepath type : (GLenum)shaderType
{
    self = [super init];
    
    if(nil != self){
        NSString* shaderCode = [ShaderCodeUtil loadShaderFromFile:filepath];
        return  [self initWithShaderCode:shaderCode type:shaderType];
    }
    
    return nil;
}

-(BOOL)loadShader : (NSString *)shaderCode
{
    self.shaderCode = shaderCode;

    const char * shaderUTF8 = [shaderCode UTF8String];
    glShaderSource(self.shader, 1, &shaderUTF8, NULL);
    
    glCompileShader(self.shader);
    
    GLint compiled = 0;
    glGetShaderiv(self.shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv ( self.shader, GL_INFO_LOG_LENGTH, &infoLen );
        
        if (infoLen > 1) {
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetShaderInfoLog (self.shader, infoLen, NULL, infoLog);
            NSLog(@"Error compiling shader:\n%s\n", infoLog );
            
            free(infoLog);
        }
        
        glDeleteShader(self.shader);
        return NO;
    }
    
    return YES;
}

+(NSString *)loadShaderFromFile:(NSString *)filepath
{
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:filepath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (!shaderString) {
        NSLog(@"Error: loading shader file: %@ %@", filepath, error.localizedDescription);
        return nil;
    }
    
    return shaderString;
}

-(void)releaseShader
{
    glDeleteShader(self.shader);
    self.shader = 0;
}

@end

@implementation ProgramUtil

-(instancetype)initWithCode : (NSString *)vertexCode fragmentCode : (NSString *)fragmentCode
{
    self = [super init];
    if(nil != self)
    {
        self.program = glCreateProgram();
        if (0 == self.program
            || nil == vertexCode
            || nil == fragmentCode
            )
            return nil;
        
        self.vertexShader = [[ShaderCodeUtil alloc] initWithShaderCode:vertexCode type:GL_VERTEX_SHADER];
        self.fragmentShader = [[ShaderCodeUtil alloc] initWithShaderCode:fragmentCode type:GL_FRAGMENT_SHADER];
        
        if(![self link])
            return nil;
    }
    return self;
}

-(instancetype)initWithShaderPath : (NSString *)vertexFilePath fragmentFilePath : (NSString *)fragmentFilePath
{
    self = [super init];
    if(nil != self){
        NSString* vertexCode = [ShaderCodeUtil loadShaderFromFile:vertexFilePath];
        NSString* fragmentCode = [ShaderCodeUtil loadShaderFromFile:fragmentFilePath];
        
        return [self initWithCode:vertexCode fragmentCode:fragmentCode];
    }
    return nil;
}

-(BOOL)link
{
    if (0 == self.program
        || nil == self.vertexShader
        || nil == self.fragmentShader
        )
        return NO;
    
    glAttachShader(self.program, self.vertexShader.shader);
    glAttachShader(self.program, self.fragmentShader.shader);
    
    glLinkProgram(self.program);
    
    GLint linked;
    glGetProgramiv(self.program, GL_LINK_STATUS, &linked);
    
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv(self.program, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1){
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(self.program, infoLen, NULL, infoLog);
            
            NSLog(@"Error linking program:\n%s\n", infoLog);
            
            free(infoLog);
        }
        
        glDeleteProgram(self.program);
        return NO;
    }
    

    [self.vertexShader releaseShader];
    [self.fragmentShader releaseShader];
    
    return YES;
}

-(void)releaseProgram
{
    glDeleteProgram(self.program);
    self.program = 0;
}

@end


