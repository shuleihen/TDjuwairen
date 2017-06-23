//
//  AliveMasterListTabelViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/23.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveTypeDefine.h"

@interface AliveMasterListTabelViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, assign) AliveMasterListType listType;

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController;
@end
