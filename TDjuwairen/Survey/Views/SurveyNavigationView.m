//
//  SurveyNavigationView.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/16.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyNavigationView.h"

@implementation SurveyNavigationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addAllButton];
    }
    return self;
}

#pragma mark - 自定义调研navigationbar
-(void)addAllButton{
    CGFloat space = 5;
    CGFloat logoWidth = 97.5;
    CGFloat logoHeight = 34;
    self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+space, logoWidth, logoHeight)];
    self.logoImage.image = [UIImage imageNamed:@"logo.png"];
    
    CGFloat searchWidth = kScreenWidth/2-space*4;
    CGFloat searchHeight = 44-space*2;
    self.searchButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2+10, 20+5, searchWidth-10, searchHeight)];
    self.searchButton.layer.cornerRadius = 5;//圆角
    self.searchButton.layer.borderWidth = 0.5;//线宽
    self.searchButton.layer.borderColor = [UIColor lightGrayColor].CGColor;  //线色
    [self.searchButton setTitle:@"关键字/股票代码" forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [self.searchButton setImageEdgeInsets:UIEdgeInsetsMake(space, 0, space, searchWidth/10)];
    [self.searchButton setBackgroundColor:[UIColor whiteColor]];
    
    
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, kScreenWidth, 1)];
    
    self.line.layer.borderWidth = 1;
    
    [self addSubview:self.logoImage];
    [self addSubview:self.searchButton];
    [self addSubview:self.line];
}


@end
