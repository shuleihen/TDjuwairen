//
//  PaperAuthorView.m
//  TDjuwairen
//
//  Created by zdy on 16/10/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "PaperAuthorView.h"

@interface PaperAuthorView()

@end

@implementation PaperAuthorView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.authorAvatarBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
        self.authorAvatarBtn.imageView.layer.cornerRadius = 25.0f;
        self.authorAvatarBtn.imageView.layer.masksToBounds = YES;
        [self.authorAvatarBtn addTarget:self action:@selector(authorAvatarPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.authorNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+50+10, 15, kScreenWidth/2, 20)];
        self.authorNameLabel.textColor = [UIColor darkGrayColor];
        self.authorNameLabel.font = [UIFont systemFontOfSize:13];
        
        self.publishDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+50+10, 15+20, kScreenWidth/2, 20)];
        self.publishDateLabel.textColor = [UIColor lightGrayColor];
        self.publishDateLabel.font = [UIFont systemFontOfSize:12];
        
        self.followBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-80, 15, 80, 40)];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [self.followBtn setTitleColor:[UIColor colorWithRed:33/255.0 green:107/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateSelected];
        self.followBtn.layer.cornerRadius = 10;
        self.followBtn.layer.borderWidth = 1;
        [self.followBtn addTarget:self action:@selector(followPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.authorAvatarBtn];
        [self addSubview:self.authorNameLabel];
        [self addSubview:self.publishDateLabel];
        [self addSubview:self.followBtn];
    }
    
    return self;
}

- (void)authorAvatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorAvatarPressed)]) {
        [self.delegate authorAvatarPressed];
    }
}

- (void)followPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(followPressed)]) {
        [self.delegate followPressed];
    }
}
@end
