//
//  AliveListBaseViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/11.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"

@interface AliveListBaseViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) AliveListType listType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *aliveList;

- (void)refreshActions;
- (void)loadMoreActions;

@end
