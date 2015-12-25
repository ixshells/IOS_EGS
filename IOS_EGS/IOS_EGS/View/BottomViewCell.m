//
//  BottomViewCell.m
//  IOS_EGS
//
//  Created by ixshells on 15/12/25.
//  Copyright © 2015年 nbcoders.com. All rights reserved.
//

#import "BottomViewCell.h"


@interface BottomViewCell()
{
    UILabel* _titleLabel;
}

@end


@implementation BottomViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(nil != self)
    {
        [self initView];
    }
    
    return self;
}

-(void)initView
{
    if(nil == _titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = RGB(100, 200, 0);
        _titleLabel.layer.cornerRadius = 8;
        _titleLabel.clipsToBounds = YES;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    _titleLabel.frame = CGRectMake(8, h/4, w - 16, h/2);
}

-(void)setTitle : (NSString *)title
{
    _titleLabel.text = title;
}

@end