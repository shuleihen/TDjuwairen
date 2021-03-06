//
//  AliveRoomLiveViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import "AliveListViewController.h"
#import "AliveTypeDefine.h"


@protocol AliveRoomLiveContentListDelegate <NSObject>

- (void)contentListLoadComplete;
@end

@interface AliveRoomLiveViewController : UIViewController
@property (nonatomic, strong) NSString *masterId;
@property (nonatomic, assign) AliveRoomListType listType;

@property (nonatomic, weak) id<AliveRoomLiveContentListDelegate> delegate;

- (CGFloat)contentHeight;
- (void)refreshAction;
- (void)loadMoreAction;
@end
