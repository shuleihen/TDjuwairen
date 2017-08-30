//
//  TDCommentTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCommentTableViewDelegate : NSObject
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIViewController *controller;

- (id)initWithTableView:(UITableView *)tableView controller:(UIViewController *)controller;

- (void)refreshData;
- (void)loadMoreData;
- (void)loadDataWithPage:(NSInteger)page;
@end
