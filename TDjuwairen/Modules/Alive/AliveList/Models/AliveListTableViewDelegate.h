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
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemList;

// 直播列表类型
@property (nonatomic, assign) AliveListType listType;

// 用户头像是否能点击，默认为YES
@property (nonatomic, assign) BOOL avatarPressedEnabled;

// 是否可以编辑删除，默认NO
@property (nonatomic, assign) BOOL canEdit;

// 是否显示动态下面的工具条，默认YES
@property (nonatomic, assign) BOOL isShowBottomView;

// 是否为直播详情页面
@property (nonatomic, assign) BOOL isAliveDetail;

// 是否滑动隐藏导航条
@property (nonatomic, assign) BOOL isHiddenNavigationBar;

@property (nonatomic, copy) void (^reloadView)(void);

- (id)initWithTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController;

- (void)setupAliveListArray:(NSArray *)array;

- (CGFloat)contentHeight;
@end
