//
//  AliveListTableViewDelegate.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/10.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "DYTableViewDelegate.h"
#import "AliveTypeDefine.h"

typedef void(^ChangeAliveListHBlock)(CGFloat contentH);


@interface AliveListTableViewDelegate : DYTableViewDelegate<UITableViewDataSource, UITableViewDelegate>

// 用户头像是否能点击，默认为YES
@property (nonatomic, assign) BOOL avatarPressedEnabled;

// 个人直播间动态可以删除
@property (nonatomic, assign) BOOL isMyRoom;

// 直播列表类型
@property (nonatomic, assign) AliveListType listType;

@property (nonatomic, copy) void (^reloadView)(void);

- (void)insertAtHeaderWithArray:(NSArray *)array;
@end
