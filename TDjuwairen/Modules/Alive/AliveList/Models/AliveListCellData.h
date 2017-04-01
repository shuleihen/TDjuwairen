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
@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) CGRect contentImgFrame;
@property (nonatomic, assign) CGRect contentTagFrame;
//@property (nonatomic, assign) 
@end
