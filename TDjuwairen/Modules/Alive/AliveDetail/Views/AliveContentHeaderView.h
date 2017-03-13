//
//  AliveContentHeaderView.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedButtonBlock)(UIButton *btn);

@interface AliveContentHeaderView : UIView
@property (copy, nonatomic) SelectedButtonBlock  selectedBlock;
- (IBAction)choiceBtnClick:(UIButton *)sender;
- (void)configShowUI:(NSInteger)selectedTag;

+ (instancetype)loadAliveContentHeaderView;


@end
