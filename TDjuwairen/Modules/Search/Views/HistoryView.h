//
//  HistoryView.h
//  TDjuwairen
//
//  Created by 团大 on 16/5/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTagsBlock)(UIButton *);
typedef void(^ClearTagsBlock)(UIButton *);

@interface HistoryView : UIView

@property (assign, nonatomic) CGRect previousFrame;
@property (assign, nonatomic) CGFloat historyViewOriginY;
@property (assign, nonatomic) CGFloat realViewHeight;

@property (nonatomic, copy) ClickTagsBlock clickblock;
@property (nonatomic, copy) ClearTagsBlock clearBlock;

- (void)setTagWithTagArray:(NSArray *)arr;
@end
