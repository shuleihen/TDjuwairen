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
@property (nonatomic, strong) AliveListModel *aliveModel;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect messageLabelFrame;
@property (nonatomic, assign) CGRect imgsViewFrame;
@property (nonatomic, assign) CGRect contentTagFrame;
@property (nonatomic, assign) CGRect forwardFrame;
@property (nonatomic, assign) CGRect tagsFrame;


@property (nonatomic, assign) BOOL isShowTags;
@property (nonatomic, assign) BOOL isShowDetail;
@property (nonatomic, assign) BOOL isShowTiedan;
// 显示查看图片
@property (nonatomic, assign) BOOL isShowReviewImageButton;
// 是否显示图片
@property (nonatomic, assign) BOOL isShowImgView;

@property (nonatomic, strong) NSAttributedString *message;

// 是否显示直播观点图片
@property (nonatomic, assign) BOOL isShowViewpointImageView;
@property (nonatomic, assign) CGRect viewpointImageViewFrame;

- (id)initWithAliveModel:(AliveListModel *)aliveModel;
- (void)setup;
@end
