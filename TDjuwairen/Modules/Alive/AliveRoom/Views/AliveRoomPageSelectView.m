//
//  AliveRoomPageSelectView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/12.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveRoomPageSelectView.h"


@interface AliveRoomPageSelectView ()

@end

@implementation AliveRoomPageSelectView

+ (instancetype)loadAliveRoomPageSelectView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"AliveRoomPageSelectView" owner:nil options:nil] lastObject];
}
- (IBAction)selectedButtonClick:(UIButton *)sender {

    
    if (self.selectedBtnBlock) {
        self.selectedBtnBlock(sender);
    }
    
    
}

- (void)showBtnUI:(NSInteger)selectedTag {

    if (selectedTag == 0) {
        self.firstButton.selected = YES;
        self.secondButton.selected = NO;
        [UIView animateWithDuration:0.1 animations:^{
        
            self.lineView.frame = CGRectMake(CGRectGetMinX(self.firstButton.frame), 44, CGRectGetWidth(self.firstButton.frame), 1);
        }];
        
    }else {
    
        self.firstButton.selected = NO;
        self.secondButton.selected = YES;
        [UIView animateWithDuration:0.1 animations:^{
        
            self.lineView.frame = CGRectMake(CGRectGetMinX(self.secondButton.frame), 44, CGRectGetWidth(self.secondButton.frame), 1);
        }];
    }
    
  
    
}

@end
