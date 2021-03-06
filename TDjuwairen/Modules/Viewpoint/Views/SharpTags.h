//
//  SharpTags.h
//  TDjuwairen
//
//  Created by 团大 on 16/6/3.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharpTagsDelegate <NSObject>

- (void)ClickTags:(UIButton *)sender;

@end

@interface SharpTags : UIView
{
    CGRect previousFrame;
    int totalHeight;
}
/* view的背景色 */
@property (nonatomic,retain) UIColor *BGColor;
/* 设置标签颜色 */
@property (nonatomic,retain) UIColor *signalTagColor;

@property (nonatomic,assign) id<SharpTagsDelegate>delegate;
/* 标签文本赋值 */
- (void)setTagWithTagArray:(NSArray *)arr;

@end
