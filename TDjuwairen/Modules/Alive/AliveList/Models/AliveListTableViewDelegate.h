//
//  AliveListTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeAliveListHBlock)(CGFloat contentH);


@interface AliveListTableViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (copy, nonatomic) ChangeAliveListHBlock  hBlock;
- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController;
- (void)reloadWithArray:(NSArray *)array;

@end
