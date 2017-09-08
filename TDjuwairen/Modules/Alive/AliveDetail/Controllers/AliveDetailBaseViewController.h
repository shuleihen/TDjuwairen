//
//  AliveDetailBaseViewController.h
//  TDjuwairen
//
//  Created by zdy on 2017/6/13.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliveTypeDefine.h"
#import "TDShareModel.h"
#import "AliveListModel.h"

@interface AliveDetailBaseViewController : UIViewController
@property (nonatomic, strong) NSString *masterID;
@property (nonatomic, strong) NSString *aliveID;
@property (nonatomic, assign) AliveType aliveType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TDShareModel *shareModel;

- (id)initWithAliveId:(NSString *)aliveId aliveType:(AliveType)aliveType;
- (void)loadTabelView;
- (void)setupIsLike:(BOOL)isLike withAnimation:(BOOL)animation;
- (void)sharePressed;
- (AliveListModel *)shareAliveListModel;
- (TDShareModel *)shareModel;
@end
