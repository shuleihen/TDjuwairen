//
//  SurveyDetailSegmentView.m
//  TDjuwairen
//
//  Created by zdy on 2016/11/29.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "SurveyDetailSegmentView.h"
#import "HexColors.h"
#import "UIImage+Create.h"

//#define SegmentItemWidth (k)/4
#define SegmentItemHeight 36
#define SegmentItemSpace 5
#define SegmentEdge 9

@implementation SurveyDetailSegmentItem
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    if (self = [super init]) {
//        self.bounds = CGRectMake(0, 0, w, SegmentItemHeight);
        /*
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SegmentItemWidth-25)/2,0 , 25, 25)];
        imageView.tag = 1;
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = image;
        imageView.highlightedImage = highlightedImage;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, SegmentItemWidth, 20)];
        titleLabel.tag = 2;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#222222"];
        titleLabel.highlightedTextColor = highlightedTextColor;
        titleLabel.text = title;
        [self addSubview:titleLabel];
        */
        
        _selectedBackgroundColor = selectedBackgroundColor;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(-2, 3, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        btn.tag = 3;
        btn.frame = self.bounds;
        
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        self.selected = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
     UIButton *btn = [self viewWithTag:3];
    
    if (frame.size.width > 0) {
        UIImage *bkNormal = [UIImage imageWithSize:CGSizeMake(frame.size.width, SegmentItemHeight)
                                    backgroudColor:[UIColor whiteColor]
                                       borderColor:[UIColor hx_colorWithHexRGBAString:@"#cccccc"]
                                        borderWidth:1.f
                                      cornerRadius:5.0f];
        UIImage *bkSelected = [UIImage imageWithSize:CGSizeMake(frame.size.width, SegmentItemHeight)
                                      backgroudColor:self.selectedBackgroundColor
                                         borderColor:self.selectedBackgroundColor
                                         borderWidth:1.f
                                        cornerRadius:5.0f];
        [btn setBackgroundImage:bkNormal forState:UIControlStateNormal];
        [btn setBackgroundImage:bkSelected forState:UIControlStateHighlighted];
        [btn setBackgroundImage:bkSelected forState:UIControlStateSelected];
    }
    
    btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setLocked:(BOOL)locked {
    _locked = locked;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
//    UIImageView *imageView = [self viewWithTag:1];
//    imageView.highlighted = selected;
//    
//    UILabel *label = [self viewWithTag:2];
//    label.highlighted = selected;
    
    UIButton *btn = [self viewWithTag:3];
    btn.selected = selected;
    
    if (selected) {
        btn.imageView.tintColor = [UIColor whiteColor];
    } else {
        btn.imageView.tintColor = [UIColor hx_colorWithHexRGBAString:@"#AAAAAA"];
    }
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
        UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 1)];
        top.backgroundColor = TDSeparatorColor;
        [self addSubview:top];
        
        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
        bottom.backgroundColor = TDSeparatorColor;
        [self addSubview:bottom];
        
        self.selectedIndex = -1;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSegments:(NSArray *)segments {
    _segments = segments;
    
    NSInteger i = 0;
    CGFloat w = (kScreenWidth-SegmentEdge*2-SegmentItemSpace*([segments count]-1))/[segments count];
    
    for (SurveyDetailSegmentItem *item in segments) {
        item.frame = CGRectMake(SegmentEdge+(SegmentItemSpace+w)*i, self.bounds.size.height - SegmentItemHeight + 5, w, SegmentItemHeight);
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
    
    for (int i=0; i<2; i++) {
        [self setLocked:isLock withIndex:i];
    }
    
    if (isLock) {
        CGFloat w = (kScreenWidth-SegmentEdge*2-SegmentItemSpace*([self.segments count]-1))/[self.segments count];
        
        UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        lockView.center = CGPointMake(SegmentEdge+w+SegmentItemSpace/2, 22);
        lockView.tag = 100;
        lockView.image = [UIImage imageNamed:@"ico_chains.png"];
        [self addSubview:lockView];
    } else {
        UIImageView *imageView = [self viewWithTag:100];
        if (imageView) {
            [imageView removeFromSuperview];
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    SurveyDetailSegmentItem *selectedItem = self.segments[selectedIndex];
    /*if (selectedItem.locked) {
        // 锁住
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegment:withIndex:)]) {
            [self.delegate didSelectedSegment:self withIndex:selectedItem.index];
        }
    } else {*/
        if (_selectedIndex >= 0) {
            SurveyDetailSegmentItem *item = self.segments[_selectedIndex];
            item.selected = NO;
        }
        
        selectedItem.selected = YES;
        _selectedIndex = selectedIndex;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegment:withIndex:)]) {
            [self.delegate didSelectedSegment:self withIndex:_selectedIndex];
        }
//    }
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
