//
//  HistoryView.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "HistoryView.h"
#import "HexColors.h"

#define HORIZONTAL_PADDING 10.0f
#define VERTICAL_PADDING   8.0f
#define LABEL_MARGIN       12.0f
#define BOTTOM_MARGIN      10.0f



@implementation HistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTagWithTagArray:(NSArray *)arr{
    previousFrame = CGRectZero;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 13, 100, 20)];
    label.text = @"历史搜索";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"#333333"];
    [self addSubview:label];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#222222"] forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#222222"] forState:UIControlStateHighlighted];
    [clearBtn setTitle:@"清除记录" forState:UIControlStateNormal];
    clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    clearBtn.frame = CGRectMake(kScreenWidth-112, 13, 100, 20);
    [clearBtn addTarget:self action:@selector(clearPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
    
    previousFrame = CGRectMake(0, 40, 0, 0);
    
    __weak HistoryView *wself = self;
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UIButton *tag = [[UIButton alloc]initWithFrame:CGRectZero];
        tag.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#f5f5f5"];
        [tag setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#333333"] forState:UIControlStateNormal];
        [tag setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#333333"] forState:UIControlStateHighlighted];
        tag.layer.cornerRadius = 4;
        tag.clipsToBounds = YES;
        tag.titleLabel.textAlignment = NSTextAlignmentCenter;
        tag.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [tag setTitle:str forState:UIControlStateNormal];
        [tag addTarget:self action:@selector(ClickTags:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
        CGSize Size_str =[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*2;
        Size_str.height += VERTICAL_PADDING*2;
        
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > (kScreenWidth-24)) {
            newRect.origin = CGPointMake(12, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        
        tag.frame = newRect;
        previousFrame = newRect;
        [wself addSubview:tag];
    }];
    
    CGFloat height = MAX(CGRectGetMaxY(previousFrame) + BOTTOM_MARGIN, kScreenHeight-64);
    self.frame = CGRectMake(0, 0, kScreenHeight, height);
    self.realViewHeight = CGRectGetMaxY(previousFrame) + BOTTOM_MARGIN;
}


- (void)ClickTags:(UIButton *)sender{
    if (self.clickblock) {
        self.clickblock(sender);
    }
}

- (void)clearPressed:(id)sender {
    if (self.clearBlock) {
        self.clearBlock(sender);
    }
}
@end
