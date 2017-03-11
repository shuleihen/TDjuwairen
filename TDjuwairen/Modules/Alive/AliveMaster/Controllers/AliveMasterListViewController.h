//
//  AliveMasterListViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AliveMasterList     =0, // 播主列表
    AliveAttentionList  =1, // 关注列表
    AliveFansList       =2, // 粉丝列表
} AliveMasterListType;

@interface AliveMasterListViewController : UIViewController
@property (nonatomic, assign) AliveMasterListType listType;
@property (nonatomic, strong) NSString *masterId;
@end
