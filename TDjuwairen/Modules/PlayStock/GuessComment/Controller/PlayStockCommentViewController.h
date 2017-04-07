//
//  PlayStockCommentViewController.h
//  TDjuwairen
//
//  Created by zdy on 2016/12/26.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kPlayStockIndex         =0,   // 股指竞猜
    kPlayStockIndividual    =1,   // 个股竞猜
} PlayStockType;

@interface PlayStockCommentViewController : UIViewController
@property (nonatomic, assign) PlayStockType playStockType;
@end
