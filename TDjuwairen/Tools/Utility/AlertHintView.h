//
//  AlertHintView.h
//  TDjuwairen
//
//  Created by 团大 on 2016/12/8.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertHintView;
typedef void (^clearBlock)(AlertHintView *view);
typedef void (^delectBlock)(AlertHintView *view);

@interface AlertHintView : UIView

+ (instancetype)alterViewWithTitle:(NSString *)title
                          content:(NSString *)content
                           cancel:(NSString *)cancel
                             sure:(NSString *)sure
                    cancelBtClcik:(clearBlock)clear
                      sureBtClcik:(delectBlock)delect;

@end
