//
//  StockCommentModel.h
//  TDjuwairen
//
//  Created by zdy on 2016/11/30.
//  Copyright © 2016年 团大网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockCommentModel : NSObject
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *stockId;
@property (nonatomic, assign) NSInteger goodNums;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *createTime;

+ (StockCommentModel *)getInstanceWithDictionary:(NSDictionary *)dic;
@end
