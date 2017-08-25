//
//  TDCommentCellData.h
//  TDjuwairen
//
//  Created by zdy on 2017/8/25.
//  Copyright © 2017年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDCommentModel.h"

@interface TDCommentCellData : NSObject
@property (nonatomic, strong) TDCommentModel *commentModel;
@property (nonatomic, strong) NSMutableAttributedString *attri;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect contentRect;
@end
