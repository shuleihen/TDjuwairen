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

//@property (nonatomic,copy) clickBtn block;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,assign) id<BottomEditDelegate>delegate;
@end
