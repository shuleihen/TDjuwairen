//
//  AliveContentHeaderView.m
//  TDjuwairen
//
//  Created by ZYP-MAC on 17/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveContentHeaderView.h"
#import "UIButton+Align.h"

@interface AliveContentHeaderView ()

@property (strong, nonatomic) UIButton *lastSelectedBtn;
@property (strong, nonatomic) UIView *selectedLineView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondeBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIView *twoLineView;
@property (weak, nonatomic) IBOutlet UIView *threeLineView;
@property (weak, nonatomic) IBOutlet UIView *oneLineView;


@end

@implementation AliveContentHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lastSelectedBtn = self.firstBtn;
    self.selectedLineView = self.oneLineView;
    _firstBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, 0);
    _secondeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, 0, -10, 0);
    _threeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, 0, -10, -10);
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
    UIView *lineV = (UIView *)[self viewWithTag:selectedTag+1000];
    btn.selected = YES;
    self.lastSelectedBtn = btn;
    self.selectedLineView.hidden = YES;
    lineV.hidden = NO;
    self.selectedLineView = lineV;
}


- (void)setShowDictM:(NSMutableDictionary *)showDictM {
    _showDictM = showDictM;
    [self.firstBtn setTitle:showDictM[@"pinglun"] forState:UIControlStateNormal];
    [self.secondeBtn setTitle:showDictM[@"dianzan"] forState:UIControlStateNormal];
    [self.threeBtn setTitle:showDictM[@"fenxiang"] forState:UIControlStateNormal];
    NSInteger index = [showDictM[@"selectedPage"] integerValue];
    [self configShowUI:index];
    
}

@end
