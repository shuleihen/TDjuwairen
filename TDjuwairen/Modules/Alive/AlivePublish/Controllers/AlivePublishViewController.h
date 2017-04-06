//
//  AlivePublishViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"
#import "AliveListModel.h"

@interface AlivePublishViewController : UITableViewController
@property (nonatomic, copy) void (^shareBlock)(BOOL state);
@property (nonatomic, assign) AlivePublishType publishType;
@property (nonatomic, strong) AliveListModel *aliveListModel;
@end
