//
//  SendCommentView.m
//  TDjuwairen
//
//  Created by 团大 on 2016/12/15.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//
#define space 15
#define btnWidth 80
#define fieldWidth kScreenWidth-3*space-btnWidth


#import "SendCommentView.h"

@implementation SendCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        self.field = [[UITextField alloc] initWithFrame:CGRectMake(space, 10, fieldWidth, 30)];
        self.field.layer.borderWidth = 1;
        self.field.layer.cornerRadius = 5;
        
        self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-space-btnWidth, 10, 80, 30)];
        self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.sendBtn setTitle:@"回答" forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:[UIColor grayColor]];
        
        [self addSubview:self.field];
        [self addSubview:self.sendBtn];
    }
    return self;
}

@end
