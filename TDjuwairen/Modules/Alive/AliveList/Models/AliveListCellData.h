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

@property (nonatomic, assign) BOOL isShowDetail;
@property (nonatomic, assign) BOOL isShowTiedan;
// 默认显示转发图片
@property (nonatomic, assign) BOOL isShowForwardImg;
@property (nonatomic, strong) NSAttributedString *message;

- (id)initWithAliveModel:(AliveListModel *)aliveModel;
- (void)setup;
@end
