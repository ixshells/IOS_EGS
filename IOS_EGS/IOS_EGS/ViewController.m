//
//  ViewController.m
//  IOS_EGS
//
//  Created by ixshells on 15/11/23.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "ViewController.h"
#import "GLViewController.h"
#import "BottomViewController.h"

@interface ViewController ()
{
    
}

@property(nonatomic, strong)EAGLContext* context;
@property(nonatomic, strong)GLViewController* glviewController;
@property(nonatomic, strong)BottomViewController* bottomViewController;

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

-(BottomViewController *)bottomViewController
{
    if(nil == _bottomViewController)
    {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(fDeviceWidth / 3.0f, 100)];
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _bottomViewController = [[BottomViewController alloc] initWithCollectionViewLayout:flowLayout];
    }
    return _bottomViewController;
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
    
    self.bottomViewController.view.frame = CGRectMake(0, fSelfViewHeight - 100, fSelfViewWidth, 100);
    [self addChildViewController:self.bottomViewController];
    [self.view addSubview:self.bottomViewController.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
