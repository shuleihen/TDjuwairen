//
//  BottomEdit.h
//  TDjuwairen
//
//  Created by 团大 on 16/7/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^clickBtn)(UIButton *);
@protocol BottomEditDelegate <NSObject>

- (void)clickEdit:(UIButton *)sender;

@end
@interface BottomEdit : UIView

@property (nonatomic,strong) UIButton *popKeyboard;

@property (nonatomic,strong) UIButton *undoBtn;

@property (nonatomic,strong) UIButton *replyBtn;

@property (nonatomic,strong) UIButton *fontBtn;

@property (nonatomic,strong) UIButton *addBtn;

@property (nonatomic,strong) UIButton *moreBtn;

//@property (nonatomic,copy) clickBtn block;
@property (nonatomic,assign) id<BottomEditDelegate>delegate;
@end
