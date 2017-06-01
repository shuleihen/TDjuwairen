//
//  DYTableViewDelegate.m
//  TDjuwairen
//
//  Created by zdy on 2017/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DYTableViewDelegate.h"

@implementation DYTableViewDelegate

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.tableView = tableView;
        self.viewController = viewController;
    }
    
    return self;
}

- (void)setupAliveListArray:(NSArray *)array {
    
}

- (CGFloat)contentHeight {
    return 0.0f;
}
@end
