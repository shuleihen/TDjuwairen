//
//  AliveMasterListViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/9.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"

typedef void(^DataArrMCountBlock)(NSInteger dataCount);

@interface AliveMasterListViewController : UIViewController
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, assign) AliveMasterListType listType;
@property (assign, nonatomic) AliveType aliveType;

@property (copy, nonatomic) DataArrMCountBlock  dataBlock;
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithDianZanVC:(UIViewController *)vc aliveId:(NSString *)aliveId  aliveType:(AliveType)aliveType viewControllerType:(AliveMasterListType)listType;
@end
