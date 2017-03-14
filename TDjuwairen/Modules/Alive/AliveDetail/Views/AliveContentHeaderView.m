//
//  AliveContentHeaderView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveContentHeaderView.h"


@interface AliveContentHeaderView ()

@property (strong, nonatomic) UIButton *lastSelectedBtn;
@property (weak, nonatomic) IBOutlet UIView *selectedLineView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondeBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@end

@implementation AliveContentHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lastSelectedBtn = self.firstBtn;
}

+ (instancetype)loadAliveContentHeaderView {
    AliveContentHeaderView *hv = [[[NSBundle mainBundle] loadNibNamed:@"AliveContentHeaderView" owner:nil options:nil] lastObject];
    
    return hv;
}


- (IBAction)choiceBtnClick:(UIButton *)sender {
    if (self.selectedBlock) {
        self.selectedBlock(sender);
    }
}

- (void)configShowUI:(NSInteger)selectedTag {
    self.lastSelectedBtn.selected = NO;
    UIButton *btn = (UIButton *)[self viewWithTag:selectedTag+100];
    
    btn.selected = YES;
    self.lastSelectedBtn = btn;
    
    self.selectedLineView.frame = CGRectMake(CGRectGetMinX(btn.frame), 43, CGRectGetWidth(btn.frame), 2);
//    self.selectedLineView.hidden = btn.selected;
}
@end
