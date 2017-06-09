//
//  AliveListTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"

typedef void(^ChangeAliveListHBlock)(CGFloat contentH);


@interface AliveListTableViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) NSArray *itemList;

// 用户头像是否能点击，默认为YES
@property (nonatomic, assign) BOOL avatarPressedEnabled;

// 直播列表类型
@property (nonatomic, assign) AliveListType listType;

@property (nonatomic, copy) void (^reloadView)(void);

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController;

- (void)setupAliveListArray:(NSArray *)array;

- (CGFloat)contentHeight;
@end
