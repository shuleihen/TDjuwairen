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
@property (nonatomic, assign) BOOL avatarPressedEnabled;

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController;

- (void)insertAtHeaderWithArray:(NSArray *)array;
- (void)reloadWithArray:(NSArray *)array;

- (CGFloat)contentHeight;
@end
