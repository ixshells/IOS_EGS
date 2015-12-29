//
//  BottomViewController.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/25.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "BottomViewController.h"
#import "RenderFac.h"
#import "BottomViewCell.h"

@interface BottomViewController()
{
    
}

@property(nonatomic, strong)NSArray* dataList;
@end

@implementation BottomViewController

-(void)viewDidLoad
{
    
    _dataList = @[@"三角形",
                  @"颜色三角形",
                  @"纹理三角形",
                  @"旋转平移缩放",
                  @"立方体",
                  @"",
                  @"",
                  ];
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[BottomViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return  self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BottomViewCell* cell;
    cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSString* title = _dataList[indexPath.row];
    [cell setTitle:title];
    UIView* selectBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectBackgroundView.backgroundColor = [UIColor blackColor];
    cell.selectedBackgroundView= selectBackgroundView;
    cell.selectedBackgroundView.backgroundColor = RGB(200, 200, 200);
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[RenderFac shareInstance] initRenderUnit:indexPath.row + 1];
    [[RenderFac shareInstance] startRender];
}


@end
