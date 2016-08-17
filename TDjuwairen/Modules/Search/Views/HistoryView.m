//
//  HistoryView.m
//  TDjuwairen
//
//  Created by 团大 on 16/5/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import "HistoryView.h"
#define HORIZONTAL_PADDING 10.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       15.0f
#define BOTTOM_MARGIN      10.0f

@interface HistoryView ()
{
    NSString *TagsTitle;
}
@end

@implementation HistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        totalHeight = 0;
        self.frame = frame;
    }
    return self;
}

- (void)setTagWithTagArray:(NSArray *)arr{
    previousFrame = CGRectZero;
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UIButton *tag = [[UIButton alloc]initWithFrame:CGRectZero];
        
        if(_signalTagColor){
            //可以单一设置tag的颜色
            tag.backgroundColor=_signalTagColor;
        }else{
            //tag颜色多样
            tag.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        tag.titleLabel.textAlignment=NSTextAlignmentCenter;
        tag.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [tag setTitle:str forState:UIControlStateNormal];
        [tag setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        tag.layer.cornerRadius=5;
        tag.layer.borderWidth = 0.8;
        tag.layer.borderColor = [UIColor grayColor].CGColor;
        tag.clipsToBounds=YES;
        /* 添加点击事件 */
        TagsTitle = str;
        [tag addTarget:self action:@selector(ClickTags:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*2;
        Size_str.height += VERTICAL_PADDING*2;
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        [tag setFrame:newRect];
        previousFrame=tag.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tag];
    }
     ];
    if(_BGColor){
        self.backgroundColor=_BGColor;
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}
#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

#pragma mark - 点击事件
- (void)ClickTags:(UIButton *)sender{
    if (self.clickblock) {
        self.clickblock(sender);
    }
}

@end
