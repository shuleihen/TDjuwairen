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
- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, SegmentItemWidth, SegmentItemHeight);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SegmentItemWidth-25)/2,0 , 25, 25)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = image;
        imageView.highlightedImage = highlightedImage;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, SegmentItemWidth, 20)];
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self sendSubviewToBack:btn];
        
    }
    return self;
}

- (void)setLocked:(BOOL)locked {
    if (locked) {
        UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake((SegmentItemWidth-25)/2, 0, 25, 25 )];
        lockView.image = [UIImage imageNamed:@"btn_locked"];
        [self addSubview:lockView];
    } else {
        
    }
}

- (void)buttonPressed:(id)sender {
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
            [self clickWithIndex:index];
        };
        i++;
    }
}

- (void)clickWithIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegment:withIndex:)]) {
        [self.delegate didSelectedSegment:self withIndex:index];
    }
}
@end
