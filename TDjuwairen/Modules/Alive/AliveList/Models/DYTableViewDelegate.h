//
//  DYTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/1.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYTableViewDelegate : NSObject
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSArray *itemList;

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController;

- (void)setupAliveListArray:(NSArray *)array;
- (CGFloat)contentHeight;
@end
