//
//  AliveListViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/7.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AliveAttention  =0,
    AliveRecommend  =1,
    AliveALL        =2,
} AliveListType;

@interface AliveListViewController : UIViewController
@property (nonatomic, assign) AliveListType listType;
@end
