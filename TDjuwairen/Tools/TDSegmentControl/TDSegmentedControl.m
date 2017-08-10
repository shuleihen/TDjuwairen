//
//  TDSegmentControl.m
//  TDjuwairen
//
//  Created by zdy on 2017/8/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDSegmentedControl.h"

@implementation TDSegmentedControl

- (id)initWithFrame:(CGRect)frame witItems:(NSArray *)items {
    if (self = [super initWithFrame:frame]) {
        _items = items;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat itemW = 52.0f;
    CGFloat offx = (w-itemW*self.items.count)/2;
    int i=0;
    
    for (NSString *string in self.items) {
        UIButton *btn = [[UIButton alloc] init];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [btn setAttributedTitle:attr forState:UIControlStateNormal];
        [btn setAttributedTitle:attr2 forState:UIControlStateHighlighted];
        [btn setAttributedTitle:attr2 forState:UIControlStateSelected];
        [btn setAttributedTitle:attr forState:UIControlStateSelected|UIControlStateHighlighted];
        
        btn.frame = CGRectMake(offx, 0, itemW, h);
        btn.tag = 200 + i++;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        offx = CGRectGetMaxX(btn.frame);
        
        UIView *red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 9)];
        red.tag = 100;
        red.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#FF5D5D"];
        red.layer.cornerRadius = 4.5f;
        red.clipsToBounds = YES;
        red.center = CGPointMake(itemW+6, h/2);
        red.hidden = YES;
        [btn addSubview:red];
        
        [self addSubview:btn];
    }
    
    UIView *slide = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 3)];
    slide.tag = 300;
    slide.layer.cornerRadius = 1.5f;
    slide.clipsToBounds = YES;
    slide.backgroundColor = [UIColor whiteColor];
    slide.center = CGPointMake((w-itemW*self.items.count)/2 + itemW/2-1, h-6);
    [self addSubview:slide];
    
    self.selectedIndex = 0;
}

- (void)setupUnread:(BOOL)unread withIndex:(NSInteger)index {
    UIView *btn = [self viewWithTag:(200 + index)];
    UIView *view = [btn viewWithTag:100];
    view.hidden = unread;
}

- (void)setupSlideWithIndex:(NSInteger)index {
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat itemW = 52.0f;
    CGFloat offx = (w-itemW*self.items.count)/2;
    
    UIView *slide = [self viewWithTag:300];
    NSTimeInterval duration = 0.3 + 0.05*self.items.count;
    
    [UIView animateWithDuration:duration animations:^{
        slide.center = CGPointMake(offx + itemW/2 + itemW*index -1, h-6);
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex >= 0 && _selectedIndex < self.items.count) {
        UIButton *btn = [self viewWithTag:(200+_selectedIndex)];
        btn.selected = NO;
    }
    
    UIButton *btn = [self viewWithTag:(200+selectedIndex)];
    btn.selected = YES;
    
    _selectedIndex = selectedIndex;
}

- (void)buttonPressed:(UIButton *)sender {
    NSInteger tag = sender.tag - 200;
    [self setupSlideWithIndex:tag];

    self.selectedIndex = tag;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
