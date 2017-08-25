//
//  TDCommentTableViewDelegate.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "TDCommentTableViewDelegate.h"

@implementation TDCommentTableViewDelegate

- (id)initWithTableView:(UITableView *)tableView controller:(UIViewController *)controller {
    if (self = [super init]) {
        self.tableView = tableView;
        self.controller = controller;
        self.page = 1;
    }
    return self;
}

- (void)refreshData {
    self.page = 1;
    [self loadDataWithPage:self.page];
}

- (void)loadMoreData {
    [self loadDataWithPage:self.page];
}

- (void)loadDataWithPage:(NSInteger)page {
    
}
@end
