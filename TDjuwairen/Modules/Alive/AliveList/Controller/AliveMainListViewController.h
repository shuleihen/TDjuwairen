//
//  AliveMainListViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/14.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kMainListRecommend,
    kMainListAttention,
} MainListType;

@interface AliveMainListViewController : UIViewController
@property (nonatomic, assign) MainListType mainListType;
@end
