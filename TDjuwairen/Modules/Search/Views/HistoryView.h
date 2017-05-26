//
//  HistoryView.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTagsBlock)(UIButton *);

@interface HistoryView : UIView
{
    CGRect previousFrame;
}

- (void)setTagWithTagArray:(NSArray *)arr;

@property (nonatomic,copy) ClickTagsBlock clickblock;
@property (nonatomic, copy) void (^clearBlock)(UIButton *);
@property (assign, nonatomic) CGFloat realViewHeight;

@end
