//
//  BackCommentView.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/20.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackCommentViewDelegate <NSObject>

- (void)clickGOBack:(UIButton *)sender;

- (void)clickComments:(UIButton *)sender;

- (void)clickShare:(UIButton *)sender;

@end
@interface BackCommentView : UIView

@property (nonatomic,strong) UITextField *commentview;

@property (nonatomic,strong) UIButton *ClickComment;
@property (nonatomic,strong) UIButton *backComment;

@property (nonatomic,strong) UIButton *ClickShare;
@property (nonatomic,strong) UIButton *backShare;

@property (nonatomic,strong) UIButton *numBtn;

@property (nonatomic,assign) id<BackCommentViewDelegate>delegate;

@end
