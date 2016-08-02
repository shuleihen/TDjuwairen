//
//  BackCommentView.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "BackCommentView.h"

@implementation BackCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
        [self addButtons];
    }
    return self;
}

#pragma mark - 设置button布局
- (void)addButtons{
    /* 返回按钮 */
    self.backback = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.backback setBackgroundColor:[UIColor clearColor]];
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(35/2, 15, 15, 20)];
    [self.backButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    
    self.commentview = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, kScreenWidth-150, 30)];
    self.commentview.layer.cornerRadius = 5;
    self.commentview.layer.borderWidth = 0.5;
    self.commentview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentview.placeholder = @"自古评论出人才，快来发表评论吧";
    /* return变成发送键 */
    self.commentview.returnKeyType = UIReturnKeySend;
    //设置清除按钮
    self.commentview.clearButtonMode = UITextFieldViewModeAlways;
    self.commentview.backgroundColor = [UIColor whiteColor];
    self.commentview.font = [UIFont systemFontOfSize:14];
    self.commentview.textAlignment = NSTextAlignmentLeft;
    
    //设置左边距
    self.commentview.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.commentview.leftViewMode = UITextFieldViewModeAlways;
    
    /* 评论按钮 */
    self.backComment = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100, 0, 50, 50)];
    [self.backComment setBackgroundColor:[UIColor clearColor]];
    
    self.ClickComment = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100+20, 15, 20, 20)];
    [self.ClickComment setBackgroundImage:[UIImage imageNamed:@"底部评论.png"] forState:UIControlStateNormal];
    
    /* 分享按钮 */
    self.backShare = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 0, 50, 50)];
    [self.backShare setBackgroundColor:[UIColor clearColor]];
    
    self.ClickShare = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50+10, 15, 20, 20)];
    [self.ClickShare setBackgroundImage:[UIImage imageNamed:@"底部分享.png"] forState:UIControlStateNormal];
    
    self.numBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100+30, 8, 20, 16)];
    
    
    [self addSubview:self.backback];
    [self addSubview:self.backButton];
    [self addSubview:self.commentview];
    [self addSubview:self.backComment];
    [self addSubview:self.ClickComment];
    [self addSubview:self.backShare];
    [self addSubview:self.ClickShare];
    [self addSubview:self.numBtn];
}

@end
