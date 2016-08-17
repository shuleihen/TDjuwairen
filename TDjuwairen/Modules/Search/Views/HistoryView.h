//
//  HistoryView.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTagsBlock)();
@interface HistoryView : UIView
{
    CGRect previousFrame;
    int totalHeight;
}
/* view的背景色 */
@property (nonatomic,retain) UIColor *BGColor;
/* 设置标签颜色 */
@property (nonatomic,retain) UIColor *signalTagColor;
/* 标签文本赋值 */
- (void)setTagWithTagArray:(NSArray *)arr;

@property (nonatomic,copy) ClickTagsBlock clickblock;
@end
