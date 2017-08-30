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
    CGFloat itemW = w/self.items.count;
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
    [self addSubview:slide];
    [self setupSlideWithIndex:0 animation:NO];
    
    self.selectedIndex = 0;
}


- (void)setAttributes:(NSDictionary *)attributes {
    for (int i=0; i<self.items.count; i++) {
        UIButton *btn = [self viewWithTag:(200+i)];
        NSString *title = self.items[i];
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:title attributes:attributes];
        [btn setAttributedTitle:attr forState:UIControlStateNormal];
        [btn setAttributedTitle:attr forState:UIControlStateSelected|UIControlStateHighlighted];
    }
}

- (void)setSelectedAttributes:(NSDictionary *)selectedAttributes {
    for (int i=0; i<self.items.count; i++) {
        UIButton *btn = [self viewWithTag:(200+i)];
        NSString *title = self.items[i];
        
        NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:title attributes:selectedAttributes];
        [btn setAttributedTitle:attr2 forState:UIControlStateHighlighted];
        [btn setAttributedTitle:attr2 forState:UIControlStateSelected];
    }
    
    UIColor *color = selectedAttributes[NSForegroundColorAttributeName];
    UIView *slide = [self viewWithTag:300];
    slide.backgroundColor = color;
}

- (void)setupUnread:(BOOL)unread withIndex:(NSInteger)index {
    UIView *btn = [self viewWithTag:(200 + index)];
    UIView *view = [btn viewWithTag:100];
    view.hidden = unread;
}

- (void)setupSlideWithIndex:(NSInteger)index animation:(BOOL)animation {
    CGFloat h = CGRectGetHeight(self.bounds);
    
    UIView *slide = [self viewWithTag:300];
    
    UIButton *btn = [self viewWithTag:(200 + index)];
    
    CGSize size = [btn.titleLabel sizeThatFits:CGSizeMake(btn.bounds.size.width, btn.bounds.size.height)];
    slide.bounds = CGRectMake(0, 0, size.width, 3);
    
    if (animation) {
        NSTimeInterval duration = 0.3 + 0.05*self.items.count;
        [UIView animateWithDuration:duration animations:^{
            slide.center = CGPointMake(btn.center.x, h-6);
        }];
    } else {
        slide.center = CGPointMake(btn.center.x, h-6);
    }
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
    [self setupSlideWithIndex:tag animation:YES];

    self.selectedIndex = tag;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
