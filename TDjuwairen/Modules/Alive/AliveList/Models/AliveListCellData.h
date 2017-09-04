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

// 顶部头像区域高度
@property (nonatomic, assign) CGFloat topHeaderHeight;

// 直播内容高度
@property (nonatomic, assign) CGFloat viewHeight;

// 底部工具条高度
@property (nonatomic, assign) CGFloat bottomHeight;

// 直播动态Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

// 直播动态
@property (nonatomic, strong) AliveListModel *aliveModel;

// 标题frame
@property (nonatomic, assign) CGRect messageLabelFrame;

// 标题
@property (nonatomic, strong) NSAttributedString *message;

// 是否全部显示标题，默认显示5行以为
@property (nonatomic, assign) BOOL isShowDetailMessage;

// 是否显示表头，默认YES
@property (nonatomic, assign) BOOL isShowHeaderView;

// 是否显示底部工具条，默认YES
@property (nonatomic, assign) BOOL isShowBottomView;

- (id)initWithAliveModel:(AliveListModel *)aliveModel;
- (void)setup;

+ (AliveListCellData *)cellDataWithAliveModel:(AliveListModel *)model;
@end


@interface AliveListPostCellData : AliveListCellData

@property (nonatomic, assign) CGRect imagesViewFrame;
@property (nonatomic, assign) CGRect tagsViewFrame;
@end

@interface AliveListViewpointCellData : AliveListCellData
@property (nonatomic, assign) BOOL isShowImageView;
@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, assign) CGRect descLabelFrame;
@end

@interface AliveListForwardCellData : AliveListCellData
@property (nonatomic, assign) CGRect forwardViewFrame;
@property (nonatomic, strong) AliveListCellData *forwardCellData;
@end

@interface AliveListPlayStockCellData : AliveListCellData
@property (nonatomic, assign) CGRect adImageFrame;
@property (nonatomic, assign) CGRect stockNameLabelFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@end

@interface AliveListStockPoolCellData : AliveListCellData
@property (nonatomic, assign) CGRect stockPoolViewFrame;
@end

@interface AliveListSurveyCellData : AliveListCellData

@end

@interface AliveListAdCellData : AliveListCellData

@end

@interface AliveListHotCellData : AliveListCellData

@end


@interface AliveListVisitCardCellData : AliveListCellData
@property (nonatomic, assign) CGRect visitCardViewFrame;
@end
