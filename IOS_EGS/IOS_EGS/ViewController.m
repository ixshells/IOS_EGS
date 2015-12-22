//
//  ViewController.m
//  IOS_EGS
//
//  Created by ixshells on 15/11/23.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "ViewController.h"
#import "GLViewController.h"

@interface ViewController ()
{
    
}

@property(nonatomic, strong)EAGLContext* context;
@property(nonatomic, strong)GLViewController* glviewController;

@end


@implementation ViewController

-(GLViewController *)glviewController
{
    if(nil == _glviewController)
    {
        _glviewController = [[GLViewController alloc] init];
    }
    return _glviewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"EGS DEMO";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self initGlView];
}


-(void)initGlView
{
    self.glviewController.view.frame = CGRectMake(0, 66, fDeviceWidth, fSelfViewHeight - 166);
    [self addChildViewController:self.glviewController];
    [self.view insertSubview:self.glviewController.view atIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
