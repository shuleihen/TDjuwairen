//
//  SurveyDetailSegmentView.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailSegmentView.h"
#import "HexColors.h"

#define SegmentItemWidth 45
#define SegmentItemHeight 50


@implementation SurveyDetailSegmentItem
- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage highlightedTextColor:(UIColor *)highlightedTextColor {
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, SegmentItemWidth, SegmentItemHeight);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SegmentItemWidth-25)/2,0 , 25, 25)];
        imageView.tag = 1;
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = image;
        imageView.highlightedImage = highlightedImage;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, SegmentItemWidth, 20)];
        titleLabel.tag = 2;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        titleLabel.highlightedTextColor = highlightedTextColor;
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 3;
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self sendSubviewToBack:btn];
        
    }
    return self;
}

- (void)setLocked:(BOOL)locked {
    _locked = locked;
    
    if (locked) {
        UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake((SegmentItemWidth-25)/2, 0, 25, 25 )];
        lockView.tag = 4;
        lockView.image = [UIImage imageNamed:@"btn_locked"];
        [self addSubview:lockView];
    } else {
        UIImageView *imageView = [self viewWithTag:4];
        if (imageView) {
            [imageView removeFromSuperview];
        }
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    UIImageView *imageView = [self viewWithTag:1];
    imageView.highlighted = selected;
    
    UILabel *label = [self viewWithTag:2];
    label.highlighted = selected;
}

- (void)buttonPressed:(id)sender {
    if (self.selected) {
        return;
    }
    
    if (self.clickBlock) {
        self.clickBlock(self.index);
    }
}


@end


@implementation SurveyDetailSegmentView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 0.5)];
        top.image = [UIImage imageNamed:@"slipLine"];
        [self addSubview:top];
        
        UIImageView *bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-0.5, CGRectGetWidth(frame), 0.5)];
        bottom.image = [UIImage imageNamed:@"slipLine"];
        [self addSubview:bottom];
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectedIndex = -1;
    }
    return self;
}

- (void)setSegments:(NSArray *)segments {
    _segments = segments;
    
    NSInteger i = 0;
    CGFloat itemW = CGRectGetWidth(self.bounds)/[segments count];
    CGFloat itemH = CGRectGetHeight(self.bounds);
    for (SurveyDetailSegmentItem *item in segments) {
        item.center = CGPointMake((i+0.5)*itemW, itemH/2);
        item.index = i;
        [self addSubview:item];
        
        item.clickBlock = ^(NSInteger index) {
            self.selectedIndex = index;
        };
        i++;
    }
}

- (void)setIsLock:(BOOL)isLock {
    _isLock = isLock;
    
    for (int i=0; i<3; i++) {
        [self setLocked:isLock withIndex:i];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    SurveyDetailSegmentItem *selectedItem = self.segments[selectedIndex];
    if (selectedItem.locked) {
        // 锁住
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegment:withIndex:)]) {
            [self.delegate didSelectedSegment:self withIndex:selectedItem.index];
        }
    } else {
        if (_selectedIndex >= 0) {
            SurveyDetailSegmentItem *item = self.segments[_selectedIndex];
            item.selected = NO;
        }
        
        selectedItem.selected = YES;
        _selectedIndex = selectedIndex;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegment:withIndex:)]) {
            [self.delegate didSelectedSegment:self withIndex:_selectedIndex];
        }
    }
}

- (void)changedSelectedIndex:(NSInteger)selectedIndex executeDelegate:(BOOL)execute {
    SurveyDetailSegmentItem *selectedItem = self.segments[selectedIndex];
    if (selectedItem.locked) {
        // 锁住
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegment:withIndex:)]) {
            [self.delegate didSelectedSegment:self withIndex:selectedItem.index];
        }
    } else {
        if (_selectedIndex >= 0) {
            SurveyDetailSegmentItem *item = self.segments[_selectedIndex];
            item.selected = NO;
        }
        
        selectedItem.selected = YES;
        _selectedIndex = selectedIndex;
        
        if (execute) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegment:withIndex:)]) {
                [self.delegate didSelectedSegment:self withIndex:_selectedIndex];
            }
        }
    }
}

- (void)setLocked:(BOOL)locked withIndex:(NSInteger)index {
    if (index >=0 && index < [self.segments count]) {
        SurveyDetailSegmentItem *item = self.segments[index];
        item.locked = locked;
    }
}
@end
