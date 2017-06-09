//
//  AliveListCellData.h
//  TDjuwairen
//
//  Created by zdy on 2017/3/30.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliveListModel.h"

@interface AliveListCellData : NSObject

// 直播动态Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

// 直播内容高度，不包含顶部用户信息
@property (nonatomic, assign) CGFloat viewHeight;

// 直播动态
@property (nonatomic, strong) AliveListModel *aliveModel;

// 标题frame
@property (nonatomic, assign) CGRect messageLabelFrame;

// 标题
@property (nonatomic, strong) NSAttributedString *message;

// 是否全部显示标题，默认显示5行以为
@property (nonatomic, assign) BOOL isShowDetailMessage;

- (id)initWithAliveModel:(AliveListModel *)aliveModel;
- (void)setup;

+ (AliveListCellData *)cellDataWithAliveModel:(AliveListModel *)model;
@end

@interface AliveListSurveyCellData : AliveListCellData

@end

@interface AliveListPostCellData : AliveListCellData

@property (nonatomic, assign) CGRect imagesViewFrame;
@property (nonatomic, assign) CGRect tagsViewFrame;
@end

@interface AliveListViewpointCellData : AliveListCellData
@property (nonatomic, assign) CGRect imageViewFrame;
@end

@interface AliveListForwardCellData : AliveListCellData
@property (nonatomic, assign) CGRect forwardViewFrame;
@property (nonatomic, strong) AliveListCellData *forwardCellData;
@end
