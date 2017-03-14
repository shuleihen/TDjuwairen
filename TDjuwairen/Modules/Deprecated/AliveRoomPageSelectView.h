//
//  AliveRoomPageSelectView.h
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedButtonClickBlock)(UIButton *sender);


@interface AliveRoomPageSelectView : UIView
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (copy, nonatomic) SelectedButtonClickBlock  selectedBtnBlock;




- (void)showBtnUI:(NSInteger)selectedTag;


+ (instancetype)loadAliveRoomPageSelectView;
@end
