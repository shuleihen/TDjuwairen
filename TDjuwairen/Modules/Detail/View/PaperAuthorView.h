//
//  PaperAuthorView.h
//  TDjuwairen
//
//  Created by zdy on 16/10/9.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaperAuthorViewDelegate <NSObject>

- (void)authorAvatarPressed;
- (void)followPressed;
@end

@interface PaperAuthorView : UIView
@property (nonatomic, strong) UIButton *authorAvatarBtn;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *publishDateLabel;
@property (nonatomic, strong) UIButton *followBtn;

@property (nonatomic, weak) id<PaperAuthorViewDelegate> delegate;
@end
